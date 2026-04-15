/**
 * Full Admin Walkthrough — single login, all use cases in one video.
 *
 * Covers: Dashboard (KPIs + quick links) → User Management (browse + add/edit/delete)
 *         → Account Requests (approve + reject) → Audit Log (search + export)
 *         → System Settings (toggles + save) → Database (backup + restore + viewer)
 *         → View As (impersonation) → Page Navigator Hub
 *         → Deletion Queue → Health Tracking Settings
 */

import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  clickText,
  ensureDemoCursor,
  fillField,
  goToAppRoute,
  loginAsAdmin,
  slowScroll,
  typeIntoPlaceholder,
  waitForFlutter,
} from './helpers';

test('Admin: Full Walkthrough', async ({ page }) => {
  test.setTimeout(600000);

  // ── Login ────────────────────────────────────────────────────────────────
  await loginAsAdmin(page);
  await ensureDemoCursor(page);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 1 — Dashboard Overview
  // ══════════════════════════════════════════════════════════════════════
  await page.waitForTimeout(2500);
  await slowScroll(page, 400, 2, 1200);
  await slowScroll(page, 400, 2, 1100);
  await slowScroll(page, 300, 1, 1000);
  await slowScroll(page, -1100, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 2 — Dashboard Actions & Quick Links
  // ══════════════════════════════════════════════════════════════════════
  const totalUsersCard = page.getByRole('button', { name: /Total Users/i }).first();
  if (await totalUsersCard.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, totalUsersCard);
    await page.waitForURL('**/admin/users', { timeout: 15000 });
    await waitForFlutter(page, 1200);
    await page.goBack();
    await waitForFlutter(page, 1200);
  }

  await slowScroll(page, 620, 1, 1000);

  const quickLinks = ['Manage Users', 'Audit Log', 'Database Viewer', 'Account Requests'];
  for (const linkName of quickLinks) {
    const chip = page.getByRole('button', { name: linkName }).first();
    if (await chip.isVisible({ timeout: 1500 }).catch(() => false)) {
      await clickLocator(page, chip);
      await page.waitForTimeout(1200);
      await waitForFlutter(page, 1000);
      await page.goBack();
      await waitForFlutter(page, 1000);
      await slowScroll(page, 620, 1, 900);
    }
  }

  const homeBtn = page.getByRole('button', { name: /HealthBank logo|navigate to dashboard/i }).first();
  if (await homeBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, homeBtn);
    await waitForFlutter(page, 1000);
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 3 — User Management (browse)
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/admin/users', 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 2, 1000);
  await slowScroll(page, 250, 1, 900);
  await slowScroll(page, -550, 1, 800);

  const addBtn = page.getByRole('button', { name: 'Add User' }).first();
  if (await addBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await addBtn.hover();
    await page.waitForTimeout(700);
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 4 — User Management Actions (add + edit + reset + deactivate + delete)
  // ══════════════════════════════════════════════════════════════════════
  const suffix = Date.now().toString().slice(-6);
  const email = `pw.user.${suffix}@hb.com`;

  await clickLocator(page, page.getByRole('button', { name: 'Add User' }).first());
  await fillField(page, 'Email', email);
  await fillField(page, 'First Name', 'Playwright');
  await fillField(page, 'Last Name', `Coverage ${suffix}`);
  await clickLocator(page, page.getByRole('button', { name: 'Save' }).last());
  await page.waitForTimeout(2000);
  await waitForFlutter(page, 1200);

  await typeIntoPlaceholder(page, 'Search by name or email...', email);
  await page.waitForTimeout(1200);

  const editButton = page.getByRole('button', { name: 'Edit user' }).first();
  if (await editButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, editButton);
    await fillField(page, 'First Name', 'PW Updated');
    await clickLocator(page, page.getByRole('button', { name: 'Save' }).last());
    await page.waitForTimeout(1800);
  }

  const resetButton = page.getByRole('button', { name: 'Reset Password' }).first();
  if (await resetButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, resetButton);
    const sendEmail = page.getByRole('checkbox', { name: /Send email/i }).first();
    if (await sendEmail.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, sendEmail);
      await page.waitForTimeout(500);
    }
    await clickLocator(page, page.getByRole('button', { name: 'Reset Password' }).last());
    await page.waitForTimeout(1800);
  }

  const deactivateButton = page.getByRole('button', { name: 'Deactivate' }).first();
  if (await deactivateButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, deactivateButton);
    await page.waitForTimeout(1200);
  }

  const activateButton = page.getByRole('button', { name: 'Activate' }).first();
  if (await activateButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, activateButton);
    await page.waitForTimeout(1200);
  }

  const deleteButton = page.getByRole('button', { name: 'Delete user' }).first();
  if (await deleteButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, deleteButton);
    const confirmDelete = page.getByRole('button', { name: 'Delete' }).last();
    if (await confirmDelete.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, confirmDelete);
      await page.waitForTimeout(1800);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 5 — Account Requests & Deletion Queue
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/admin/messages', 1500);
  await page.waitForURL('**/admin/messages', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 1000);

  // Approve or reject any pending requests if present
  const approveButton = page.getByRole('button', { name: 'Approve' }).first();
  if (await approveButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await approveButton.hover();
    await page.waitForTimeout(800);
    const rejectButton = page.getByRole('button', { name: 'Reject' }).first();
    if (await rejectButton.isVisible({ timeout: 2000 }).catch(() => false)) {
      await rejectButton.hover();
      await page.waitForTimeout(700);
    }
  }

  // Switch to Deletion Requests tab
  await clickText(page, 'Deletion Requests');
  await page.waitForTimeout(1200);
  await waitForFlutter(page, 1000);
  await slowScroll(page, 200, 1, 900);
  await slowScroll(page, -220, 1, 700);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 6 — Audit Log & Export
  // ══════════════════════════════════════════════════════════════════════
  await clickButton(page, 'Audit Log');
  await page.waitForURL('**/admin/logs', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1500);
  await slowScroll(page, 350, 2, 1100);

  const firstRow = page.getByRole('row').nth(1);
  if (await firstRow.isVisible({ timeout: 3000 }).catch(() => false)) {
    await firstRow.click();
    await page.waitForTimeout(1500);
    await slowScroll(page, 200, 1, 900);
    await firstRow.click();
    await page.waitForTimeout(800);
  }

  await fillField(page, 'Search', 'login');
  await page.waitForTimeout(1500);
  await slowScroll(page, 200, 1, 800);
  await fillField(page, 'Search', '');
  await page.waitForTimeout(800);

  await slowScroll(page, 220, 1, 800);
  const exportBtn = page.getByRole('button', { name: 'Export as CSV' }).first();
  if (await exportBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, exportBtn);
    await page.waitForTimeout(1800);
  }

  await slowScroll(page, -600, 1, 800);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 7 — System Settings
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/admin/settings', 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 250, 1, 1000);
  await slowScroll(page, 200, 1, 900);
  await slowScroll(page, 300, 1, 1000);
  await slowScroll(page, 300, 1, 1000);

  const saveBtn = page.getByRole('button', { name: 'Save Changes' }).first();
  if (await saveBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await saveBtn.hover();
    await page.waitForTimeout(800);
  }

  // Toggle a setting and save
  const switches = page.getByRole('switch');
  const switchCount = await switches.count();
  if (switchCount > 0) {
    await clickLocator(page, switches.nth(0));
    await page.waitForTimeout(600);
    await clickLocator(page, page.getByRole('button', { name: 'Save Changes' }).last());
    await page.waitForTimeout(1800);
    // Revert
    await clickLocator(page, switches.nth(0));
    await page.waitForTimeout(600);
    await clickLocator(page, page.getByRole('button', { name: 'Save Changes' }).last());
    await page.waitForTimeout(1800);
  }

  await slowScroll(page, -1300, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 8 — Database Viewer & Backup Lifecycle
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/admin/database', 1500);
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1800);
  await slowScroll(page, 250, 1, 1000);

  // Create a manual backup
  const createBackupBtn = page.getByRole('button', { name: 'Create Backup Now' }).first();
  if (await createBackupBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, createBackupBtn);
    await page.waitForTimeout(3000);
  }

  // Download the first backup
  const downloadButton = page.getByRole('button', { name: 'Download backup file' }).first();
  if (await downloadButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, downloadButton);
    await page.waitForTimeout(1500);
  }

  // Delete the manual backup
  const deleteBackupBtn = page.getByRole('button', { name: 'Delete this backup' }).first();
  if (await deleteBackupBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, deleteBackupBtn);
    const confirmDeleteBackup = page.getByRole('button', { name: 'Delete' }).last();
    if (await confirmDeleteBackup.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, confirmDeleteBackup);
      await page.waitForTimeout(1800);
    }
  }

  // ── Restore from Backup ────────────────────────────────────────────────
  await slowScroll(page, 300, 2, 900);
  await waitForFlutter(page, 800);

  const restoreDropdown = page.getByRole('combobox', { name: /Select Backup/i }).first();
  const fallbackDropdown = page.getByRole('combobox').last();
  const restoreCombo = await restoreDropdown.isVisible({ timeout: 3000 }).catch(() => false)
    ? restoreDropdown
    : fallbackDropdown;

  if (await restoreCombo.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, restoreCombo);
    await page.waitForTimeout(1000);
    const firstOption = page.getByRole('option').first();
    if (await firstOption.isVisible({ timeout: 2000 }).catch(() => false)) {
      await firstOption.click();
      await page.waitForTimeout(800);
    }
  }

  const restoreBtn = page.getByRole('button', { name: /Restore Database/i }).first();
  if (await restoreBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, restoreBtn);
    await page.waitForTimeout(2500);
    const cancelRestore = page.getByRole('button', { name: /Cancel/i }).last();
    if (await cancelRestore.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, cancelRestore);
      await page.waitForTimeout(1000);
    }
  }

  // ── Database viewer ────────────────────────────────────────────────────
  await slowScroll(page, 400, 2, 1100);

  const firstTable = page.getByRole('button').filter({ hasText: /Account|User|Survey/i }).first();
  if (await firstTable.isVisible({ timeout: 4000 }).catch(() => false)) {
    await firstTable.click();
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 300, 1, 1000);
    await firstTable.click();
    await page.waitForTimeout(800);
  }

  await slowScroll(page, -800, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 9 — View As (Impersonation)
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/admin/dashboard', 1500);
  await waitForFlutter(page, 1200);

  const viewAsBtn = page.getByRole('button', { name: /view as/i }).first();
  if (await viewAsBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await viewAsBtn.click();
    await page.waitForTimeout(1000);
  } else {
    const viewAsLabel = page.getByText('View As', { exact: false }).first();
    if (await viewAsLabel.isVisible({ timeout: 4000 }).catch(() => false)) {
      await clickLocator(page, viewAsLabel);
      await page.waitForTimeout(1000);
    }
  }
  await waitForFlutter(page, 800);

  const dropdown = page.getByRole('combobox').first();
  if (await dropdown.isVisible({ timeout: 4000 }).catch(() => false)) {
    await dropdown.click();
    await page.waitForTimeout(700);
    const firstOption = page.getByRole('option').first();
    if (await firstOption.isVisible({ timeout: 3000 }).catch(() => false)) {
      await firstOption.click();
      await page.waitForTimeout(1500);
    }
  }

  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1800);
  await slowScroll(page, 300, 1, 1000);

  const backToAdmin = page.getByRole('button', { name: /back to admin/i }).first();
  if (await backToAdmin.isVisible({ timeout: 5000 }).catch(() => false)) {
    await backToAdmin.click();
    await page.waitForTimeout(2000);
  }

  // Always navigate explicitly to the admin dashboard so the subsequent
  // sections start from a known-good state, regardless of where "Back to
  // Admin" landed (it can redirect to a 404 or the impersonation return URL).
  await goToAppRoute(page, '/admin', 1500);
  // If we got bounced to /login, the session was dropped — re-login.
  if (page.url().includes('/login') || page.url().includes('/home')) {
    await loginAsAdmin(page);
    await ensureDemoCursor(page);
  }
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 10 — Page Navigator Hub
  // ══════════════════════════════════════════════════════════════════════
  await clickButton(page, 'Page Navigator');
  await page.waitForURL('**/admin/nav-hub', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 280, 1, 1000);
  await slowScroll(page, 280, 1, 1000);
  await slowScroll(page, 280, 1, 1000);
  await slowScroll(page, 280, 1, 1000);
  await slowScroll(page, 280, 1, 1000);
  await slowScroll(page, -1400, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 11 — Health Tracking Settings
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/admin/health-tracking', 1500);
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1800);

  // Expand Physical Health category
  const physicalRow = page.getByRole('button', { name: /Physical Health/i }).first();
  if (await physicalRow.isVisible({ timeout: 5000 }).catch(() => false)) {
    await clickLocator(page, physicalRow);
  } else {
    await clickText(page, 'Physical Health');
  }
  await page.waitForTimeout(1400);
  await waitForFlutter(page, 800);
  await slowScroll(page, 260, 2, 900);
  await page.waitForTimeout(1200);

  // Add Category dialog (cancel)
  const addCategoryBtn = page.getByRole('button', { name: /Add Category/i }).first();
  if (await addCategoryBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, addCategoryBtn);
    await page.waitForTimeout(1400);
    await fillField(page, 'Category Name', 'Demo Category');
    await page.waitForTimeout(1000);
    const cancelCat = page.getByRole('button', { name: /Cancel/i }).first();
    if (await cancelCat.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, cancelCat);
      await page.waitForTimeout(1200);
    }
  }

  // Edit first metric (cancel)
  const editMetricBtn = page.getByRole('button', { name: /Edit metric|Edit|pencil/i }).first();
  if (await editMetricBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, editMetricBtn);
    await page.waitForTimeout(1400);
    await waitForFlutter(page, 800);
    await slowScroll(page, 200, 1, 900);
    const cancelEdit = page.getByRole('button', { name: /Cancel/i }).first();
    if (await cancelEdit.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, cancelEdit);
      await page.waitForTimeout(1200);
    }
  }

  // Toggle first metric active/inactive and back
  const toggleMetricBtn = page.getByRole('switch').first();
  if (await toggleMetricBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, toggleMetricBtn);
    await page.waitForTimeout(1200);
    await clickLocator(page, toggleMetricBtn);
    await page.waitForTimeout(1200);
  }

  await slowScroll(page, -300, 1, 800);
  await page.waitForTimeout(2000);
});
