import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  loginAsHcp,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('HCP: My Patients List', async ({ page }) => {
  await loginAsHcp(page);

  // Navigate to Clients / My Patients
  await clickButton(page, 'Clients');
  await page.waitForURL('**/hcp/clients', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Browse the linked patients section
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 1000);

  // Expand the first linked patient card to reveal their completed surveys
  const firstPatientCard = page.getByRole('button', { name: /View Surveys|Expand/ }).first();
  if (await firstPatientCard.isVisible({ timeout: 3000 }).catch(() => false)) {
    await firstPatientCard.click();
    await page.waitForTimeout(1200);
    await slowScroll(page, 200, 1, 900);
  } else {
    // Try clicking the first expandable row (Flutter ExpansionTile)
    const expandable = page.getByText('Linked since', { exact: false }).first();
    if (await expandable.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, expandable);
      await page.waitForTimeout(1200);
      await slowScroll(page, 200, 1, 900);
    }
  }

  // Scroll to show pending requests section
  await slowScroll(page, 300, 1, 1000);
  await slowScroll(page, -500, 1, 800);

  await waitForFlutter(page, 800);
});
