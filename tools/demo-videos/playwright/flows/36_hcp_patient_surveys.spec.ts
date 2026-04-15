import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsHcp,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('HCP: View Patient Completed Surveys', async ({ page }) => {
  await loginAsHcp(page);

  // Navigate to My Patients
  await clickButton(page, 'Clients');
  await page.waitForURL('**/hcp/clients', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1000);

  // Expand the first linked patient to see their surveys
  const viewSurveysBtn = page.getByRole('button', { name: 'View Surveys' }).first();
  if (await viewSurveysBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await viewSurveysBtn.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 300, 1, 1000);
    await slowScroll(page, -200, 1, 800);
  } else {
    // Try expanding via a "Linked since" row (ExpansionTile header)
    const patientRow = page.getByText('Linked since', { exact: false }).first();
    if (await patientRow.isVisible({ timeout: 4000 }).catch(() => false)) {
      await clickLocator(page, patientRow);
      await page.waitForTimeout(1500);
      await waitForFlutter(page, 1000);
      await slowScroll(page, 300, 1, 1000);

      // Click View Surveys if it appeared after expansion
      const vsBtn = page.getByRole('button', { name: 'View Surveys' }).first();
      if (await vsBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
        await vsBtn.click();
        await page.waitForTimeout(1500);
        await slowScroll(page, 200, 1, 900);
      }
    }
  }

  await waitForFlutter(page, 800);
});
