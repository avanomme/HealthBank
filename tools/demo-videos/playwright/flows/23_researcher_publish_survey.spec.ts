/**
 * Researcher: Publish a draft survey.
 *
 * Flow:
 *   Surveys → filter Drafts → Edit first draft →
 *   review questions → click Publish → confirm dialog → success toast
 *
 * Also demonstrates the Preview Survey button before publishing.
 */
import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  goToAppRoute,
  loginAsResearcher,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Publish Survey', async ({ page }) => {
  await loginAsResearcher(page);

  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  const clearAll = page.getByRole('button', { name: 'Clear All' }).first();
  if (await clearAll.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clearAll.click();
    await page.waitForTimeout(800);
  }

  // ── Find a draft to publish ────────────────────────────────────────────
  await selectDropdownOption(page, page.getByRole('button', { name: /Status/ }).first(), 1);
  await page.waitForTimeout(1200);

  // Open the first draft via "View Survey Status"
  const statusBtn = page.getByRole('button', { name: 'View Survey Status' }).first();
  if (await statusBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await statusBtn.click();
    await page.waitForURL('**/surveys/**/status', { timeout: 15000 });
    await waitForFlutter(page, 1800);

    // The status page shows Edit + Publish buttons for draft surveys
    await slowScroll(page, 200, 1, 800);

    // Click Publish from the status page
    const publishBtn = page.getByRole('button', { name: 'Publish' }).first();
    if (await publishBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
      await publishBtn.click();
      await page.waitForTimeout(1200);

      // Confirm the publish dialog
      const confirmPublish = page.getByRole('button', { name: 'Publish' }).last();
      if (await confirmPublish.isVisible({ timeout: 4000 }).catch(() => false)) {
        await confirmPublish.click();
        await page.waitForTimeout(2500);
      }
    }
  } else {
    // Fallback: go directly into edit mode and publish from the builder
    const editBtn = page.getByRole('button', { name: 'Edit' }).first();
    if (await editBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
      await editBtn.click();
      await page.waitForURL('**/surveys/**/edit', { timeout: 15000 });
      await waitForFlutter(page, 1500);

      // Preview the survey before publishing (shows the preview icon button)
      const previewBtn = page.getByRole('button', { name: 'Preview Survey' });
      if (await previewBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
        await previewBtn.click();
        await page.waitForTimeout(1500);
        await slowScroll(page, 200, 1, 800);
        await page.keyboard.press('Escape');
        await page.waitForTimeout(700);
      }

      await slowScroll(page, 200, 1, 800);

      // Publish from the builder toolbar
      await clickButton(page, 'Publish');
      await page.waitForTimeout(1200);

      // Confirm
      const confirmPublish = page.getByRole('button', { name: 'Publish' }).last();
      if (await confirmPublish.isVisible({ timeout: 4000 }).catch(() => false)) {
        await confirmPublish.click();
        await page.waitForTimeout(2500);
      }
    }
  }

  await waitForFlutter(page, 1000);
});
