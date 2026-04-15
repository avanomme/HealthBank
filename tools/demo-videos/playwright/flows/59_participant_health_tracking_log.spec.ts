import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  clickText,
  ensureDemoCursor,
  goToAppRoute,
  loginAsParticipant,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Health Tracking — Log Entries', async ({ page }) => {
  await loginAsParticipant(page);

  await goToAppRoute(page, '/participant/health-tracking', 1500);
  await waitForFlutter(page, 1500);
  await ensureDemoCursor(page);

  // Pause to show the page — baseline banner and category chips visible
  await page.waitForTimeout(1800);

  // Slow scroll down slightly to reveal metric cards
  await slowScroll(page, 220, 1, 900);
  await page.waitForTimeout(1200);

  // Physical Health is the default selected category — hover over its chip to highlight it
  const physicalChip = page.getByRole('button', { name: /Physical Health/i }).first();
  if (await physicalChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, physicalChip);
    await page.waitForTimeout(1000);
  }

  // Interact with the first visible Yes/No or scale metric
  // Try a button labelled "Yes" first (yes/no chip), fall back to any visible scale option
  const yesChip = page.getByRole('button', { name: /^Yes$/i }).first();
  if (await yesChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, yesChip);
    await page.waitForTimeout(1000);
  } else {
    // Try the first radio/option button rendered for a scale slider metric
    const scaleOption = page.getByRole('radio').first();
    if (await scaleOption.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, scaleOption);
      await page.waitForTimeout(1000);
    }
  }

  // Switch to Mental Health category
  const mentalChip = page.getByRole('button', { name: /Mental Health/i }).first();
  if (await mentalChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, mentalChip);
  } else if (await page.getByText('Mental Health', { exact: false }).first().isVisible({ timeout: 1000 }).catch(() => false)) {
    await clickText(page, 'Mental Health');
  }
  await page.waitForTimeout(1400);

  // Interact with a metric in the Mental Health category
  const mentalYes = page.getByRole('button', { name: /^Yes$/i }).first();
  if (await mentalYes.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, mentalYes);
    await page.waitForTimeout(1000);
  } else {
    const mentalScale = page.getByRole('radio').first();
    if (await mentalScale.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, mentalScale);
      await page.waitForTimeout(1000);
    }
  }

  // Click the Save Entries button
  const saveEntriesButton = page.getByRole('button', { name: /Save Entries/i }).first();
  if (await saveEntriesButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, saveEntriesButton);
    await page.waitForTimeout(2000);
  }

  // Pause to let the success snackbar animate in and remain visible
  await page.waitForTimeout(1500);
});
