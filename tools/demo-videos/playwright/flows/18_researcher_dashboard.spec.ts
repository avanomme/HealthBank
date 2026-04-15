import { test } from '@playwright/test';
import { loginAsResearcher, slowScroll, waitForFlutter } from './helpers';

test('Researcher: Dashboard Overview', async ({ page }) => {
  await loginAsResearcher(page);

  // Let the dashboard settle and show KPI cards
  await page.waitForTimeout(2000);

  // Scroll down to reveal charts and recent surveys
  await slowScroll(page, 400, 2, 1200);

  // Scroll back to top
  await slowScroll(page, -400, 1, 1000);

  // Expand / collapse the sidebar
  const expandBtn = page.getByRole('button', { name: 'Expand sidebar' });
  if (await expandBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await expandBtn.click();
    await page.waitForTimeout(900);
  }

  await waitForFlutter(page, 1000);

  // Scroll through the full dashboard one more time
  await slowScroll(page, 600, 2, 1100);
  await slowScroll(page, -600, 1, 900);
});
