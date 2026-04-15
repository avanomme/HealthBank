/**
 * Full HCP Walkthrough — single login, all use cases in one video.
 *
 * Covers: Dashboard → My Patients (browse + expand) → Request Patient Link
 *         → View Patient Surveys → Patient Reports
 */

import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  fillField,
  loginAsHcp,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('HCP: Full Walkthrough', async ({ page }) => {
  test.setTimeout(300000);

  // ── Login ────────────────────────────────────────────────────────────────
  await loginAsHcp(page);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 1 — Dashboard
  // ══════════════════════════════════════════════════════════════════════
  await page.waitForTimeout(2500);
  await slowScroll(page, 300, 1, 1100);
  await slowScroll(page, 300, 1, 1000);
  await slowScroll(page, -600, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 2 — My Patients List
  // ══════════════════════════════════════════════════════════════════════
  await clickButton(page, 'Clients');
  await page.waitForURL('**/hcp/clients', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 1000);

  // Expand the first linked patient card
  const viewSurveysBtn = page.getByRole('button', { name: 'View Surveys' }).first();
  if (await viewSurveysBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await viewSurveysBtn.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 300, 1, 1000);
    await slowScroll(page, -200, 1, 800);
  } else {
    const expandable = page.getByText('Linked since', { exact: false }).first();
    if (await expandable.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, expandable);
      await page.waitForTimeout(1200);
      await slowScroll(page, 200, 1, 900);
    }
  }

  // Show pending requests section
  await slowScroll(page, 300, 1, 1000);
  await slowScroll(page, -500, 1, 800);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 3 — Request Patient Link
  // ══════════════════════════════════════════════════════════════════════
  const requestLinkBtn = page.getByRole('button', { name: 'Request Patient Link' }).first();
  if (await requestLinkBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, requestLinkBtn);
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 800);

    await fillField(page, 'Patient email address', 'john.smith@email.com');
    await page.waitForTimeout(1500);

    // Cancel so we don't send a duplicate request
    const cancelBtn = page.getByRole('button', { name: /cancel/i }).first();
    if (await cancelBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await cancelBtn.click();
      await page.waitForTimeout(700);
    } else {
      await page.keyboard.press('Escape');
      await page.waitForTimeout(700);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 4 — View Patient Completed Surveys
  // ══════════════════════════════════════════════════════════════════════
  const viewSurveysBtn2 = page.getByRole('button', { name: 'View Surveys' }).first();
  if (await viewSurveysBtn2.isVisible({ timeout: 4000 }).catch(() => false)) {
    await viewSurveysBtn2.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 300, 1, 1000);
    await slowScroll(page, -200, 1, 800);
  } else {
    const patientRow = page.getByText('Linked since', { exact: false }).first();
    if (await patientRow.isVisible({ timeout: 4000 }).catch(() => false)) {
      await clickLocator(page, patientRow);
      await page.waitForTimeout(1500);
      await waitForFlutter(page, 1000);
      await slowScroll(page, 300, 1, 1000);
      const vsBtn = page.getByRole('button', { name: 'View Surveys' }).first();
      if (await vsBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
        await vsBtn.click();
        await page.waitForTimeout(1500);
        await slowScroll(page, 200, 1, 900);
      }
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 5 — Patient Reports
  // ══════════════════════════════════════════════════════════════════════
  await clickButton(page, 'Reports');
  await page.waitForURL('**/hcp/reports', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Select a patient
  const patientDropdown = page.getByRole('combobox').first();
  if (await patientDropdown.isVisible({ timeout: 4000 }).catch(() => false)) {
    await selectDropdownOption(page, patientDropdown, 1);
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 1000);
  } else {
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

  // Select a survey
  const surveyDropdown = page.getByRole('combobox').nth(1);
  if (await surveyDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await selectDropdownOption(page, surveyDropdown, 1);
    await page.waitForTimeout(1500);
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
  await slowScroll(page, 350, 2, 1100);
  await slowScroll(page, -300, 1, 900);

  // Health Tracking tab if visible
  const healthTrackingTab = page.getByRole('tab', { name: /Health Tracking/i }).first();
  if (await healthTrackingTab.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, healthTrackingTab);
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 300, 2, 1000);
    await slowScroll(page, -300, 1, 800);
  }

  await page.waitForTimeout(2000);
});
