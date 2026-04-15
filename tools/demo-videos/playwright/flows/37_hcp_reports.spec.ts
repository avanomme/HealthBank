import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsHcp,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('HCP: Patient Reports', async ({ page }) => {
  await loginAsHcp(page);

  // Navigate to Reports
  await clickButton(page, 'Reports');
  await page.waitForURL('**/hcp/reports', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Step 1: select a patient from the dropdown
  const patientDropdown = page.getByRole('combobox').first();
  if (await patientDropdown.isVisible({ timeout: 4000 }).catch(() => false)) {
    await patientDropdown.click();
    await page.waitForTimeout(800);
    const firstOption = page.getByRole('option').first();
    if (await firstOption.isVisible({ timeout: 3000 }).catch(() => false)) {
      await firstOption.click();
      await page.waitForTimeout(1200);
    }
  } else {
    // Fallback: click the "Select a Patient" text
    const selectPatient = page.getByText('Select a Patient', { exact: false }).first();
    if (await selectPatient.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, selectPatient);
      await page.waitForTimeout(800);
      const firstOption = page.getByRole('option').first();
      if (await firstOption.isVisible({ timeout: 3000 }).catch(() => false)) {
        await firstOption.click();
        await page.waitForTimeout(1200);
      }
    }
  }

  await waitForFlutter(page, 1000);

  // Step 2: select a survey once the survey dropdown appears
  const surveyDropdown = page.getByRole('combobox').nth(1);
  if (await surveyDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await surveyDropdown.click();
    await page.waitForTimeout(800);
    const firstSurvey = page.getByRole('option').first();
    if (await firstSurvey.isVisible({ timeout: 3000 }).catch(() => false)) {
      await firstSurvey.click();
      await page.waitForTimeout(1500);
    }
  } else {
    const selectSurvey = page.getByText('Select a Survey', { exact: false }).first();
    if (await selectSurvey.isVisible({ timeout: 4000 }).catch(() => false)) {
      await clickLocator(page, selectSurvey);
      await page.waitForTimeout(800);
      const firstSurvey = page.getByRole('option').first();
      if (await firstSurvey.isVisible({ timeout: 3000 }).catch(() => false)) {
        await firstSurvey.click();
        await page.waitForTimeout(1500);
      }
    }
  }

  await waitForFlutter(page, 1500);

  // Step 3: the response table is now visible — scroll through it
  await slowScroll(page, 350, 2, 1100);
  await slowScroll(page, -300, 1, 900);

  await waitForFlutter(page, 800);
});
