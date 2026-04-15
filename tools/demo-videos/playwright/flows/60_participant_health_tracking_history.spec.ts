import { test } from '@playwright/test';
import {
  clickText,
  ensureDemoCursor,
  goToAppRoute,
  loginAsParticipant,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Health Tracking — View History', async ({ page }) => {
  await loginAsParticipant(page);

  await goToAppRoute(page, '/participant/health-tracking', 1500);
  await waitForFlutter(page, 1500);
  await ensureDemoCursor(page);

  // Pause briefly on the Log tab so the viewer sees the starting context
  await page.waitForTimeout(1200);

  // Click the History tab
  await clickText(page, 'History');
  await page.waitForTimeout(1800);

  // Wait for tab content to settle
  await waitForFlutter(page, 1000);

  // Interact with the Category dropdown — move down 1 item and select it
  const categoryDropdown = page.getByRole('combobox').first();
  if (await categoryDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await selectDropdownOption(page, categoryDropdown, 1);
    await page.waitForTimeout(1200);
  } else {
    // Fallback: try to find a button labelled Category or a listbox
    const categoryButton = page.getByRole('button', { name: /Category/i }).first();
    if (await categoryButton.isVisible({ timeout: 3000 }).catch(() => false)) {
      await selectDropdownOption(page, categoryButton, 1);
      await page.waitForTimeout(1200);
    }
  }

  // Interact with the Metric dropdown — select the first metric
  const metricDropdown = page.getByRole('combobox').nth(1);
  if (await metricDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await selectDropdownOption(page, metricDropdown, 1);
    await page.waitForTimeout(1200);
  } else {
    const metricButton = page.getByRole('button', { name: /Metric/i }).first();
    if (await metricButton.isVisible({ timeout: 3000 }).catch(() => false)) {
      await selectDropdownOption(page, metricButton, 1);
      await page.waitForTimeout(1200);
    }
  }

  // Pause to show the chart loading / rendering
  await page.waitForTimeout(1600);

  // Slow scroll to show recent entries listed below the chart
  await slowScroll(page, 320, 2, 900);
  await page.waitForTimeout(1500);
});
