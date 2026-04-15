import { test } from '@playwright/test';
import {
  clickButton,
  fillField,
  loginAsResearcher,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Create New Template', async ({ page }) => {
  await loginAsResearcher(page);

  // Navigate to Templates
  await clickButton(page, 'Templates');
  await page.waitForURL('**/templates', { timeout: 15000 });
  await waitForFlutter(page, 1200);

  const backBtn = page.getByRole('button', { name: 'Back' }).first();
  if (await backBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
    await backBtn.click();
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 1200);
  }

  // Open template builder
  await clickButton(page, 'New Template');
  await waitForFlutter(page, 1500);

  // Fill template title
  await fillField(page, 'Template Title *', 'Annual Wellness Check');
  await page.waitForTimeout(600);

  // Fill description
  await fillField(page, 'Description (optional)', 'Comprehensive annual wellness screening questions.');
  await page.waitForTimeout(600);

  // Toggle the Public Template switch on
  const publicSwitch = page.getByRole('switch', { name: /public/i }).first();
  if (await publicSwitch.isVisible({ timeout: 3000 }).catch(() => false)) {
    await publicSwitch.click();
    await page.waitForTimeout(700);
  }

  // Add questions from the question bank
  await clickButton(page, 'Add Questions');
  await page.waitForTimeout(1200);
  await waitForFlutter(page, 1000);

  // Select a few questions
  const firstCheckbox = page.getByRole('checkbox').first();
  if (await firstCheckbox.isVisible({ timeout: 3000 }).catch(() => false)) {
    await firstCheckbox.click();
    await page.waitForTimeout(500);
    const secondCheckbox = page.getByRole('checkbox').nth(1);
    if (await secondCheckbox.isVisible({ timeout: 2000 }).catch(() => false)) {
      await secondCheckbox.click();
      await page.waitForTimeout(500);
    }
    // Confirm selection
    const addBtn = page.getByRole('button', { name: /Add \(/ }).first();
    if (await addBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await addBtn.click();
      await page.waitForTimeout(1000);
    }
  }

  await slowScroll(page, 300, 1, 900);

  // Save the template
  await clickButton(page, 'Save');
  await page.waitForTimeout(2500);
  await waitForFlutter(page, 1000);
});
