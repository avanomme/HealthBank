/**
 * Full Participant Walkthrough — single login, all use cases in one video.
 *
 * Covers: Dashboard → Tasks → Health Tracking (metric types, log, history, baseline)
 *         → Surveys (resume + start) → Results → Messaging
 *         → Language options → Profile edit → Settings (appearance + security)
 *
 * Health Tracking runs early (before any profile/settings mutations) to ensure
 * the session and Flutter app are in a clean state when navigating those pages.
 */

import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  clickText,
  ensureDemoCursor,
  fillField,
  goToAppRoute,
  loginAsParticipant,
  resetParticipantDemoState,
  selectAccountMenuItem,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
  waitForHash,
} from './helpers';

test('Participant: Full Walkthrough', async ({ page }) => {
  test.setTimeout(600000);

  // ── Setup & Login ───────────────────────────────────────────────────────────
  resetParticipantDemoState();
  await loginAsParticipant(page);
  await ensureDemoCursor(page);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 1 — Dashboard
  // ══════════════════════════════════════════════════════════════════════
  await page.waitForTimeout(2500);
  await slowScroll(page, 420, 2, 1100);
  await slowScroll(page, 420, 2, 1100);
  await slowScroll(page, -900, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 2 — Tasks & Alerts
  // ══════════════════════════════════════════════════════════════════════
  await clickButton(page, 'To-Do');
  await page.waitForURL('**/participant/tasks', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);

  const acceptBtn = page.getByRole('button', { name: 'Accept' }).first();
  if (await acceptBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await acceptBtn.click();
    await page.waitForTimeout(1800);
  }
  await slowScroll(page, 380, 2, 1000);
  await slowScroll(page, -220, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTIONS 3-6 — Health Tracking
  // History is shown FIRST (before metric interactions) because SegmentedButton
  // segments become inaccessible after Flutter rebuilds triggered by sliders/chips.
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/participant/health-tracking', 2000);
  await page.waitForTimeout(1500);

  // ── 5: History tab (FIRST — SegmentedButton segment, role=button) ─────
  await clickButton(page, 'History');
  await page.waitForTimeout(1800);
  await waitForFlutter(page, 1000);

  const categoryDropdown = page.getByRole('combobox').first();
  if (await categoryDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await selectDropdownOption(page, categoryDropdown, 1);
    await page.waitForTimeout(1200);
  }

  const metricDropdown = page.getByRole('combobox').nth(1);
  if (await metricDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await selectDropdownOption(page, metricDropdown, 1);
    await page.waitForTimeout(1200);
  }

  await page.waitForTimeout(1600);
  await slowScroll(page, 320, 2, 900);
  await page.waitForTimeout(1500);

  // ── Back to Log Today ──────────────────────────────────────────────────
  await clickButton(page, 'Log Today');
  await page.waitForTimeout(1200);
  await waitForFlutter(page, 800);

  // ── 3: Metric Input Types ──────────────────────────────────────────────
  await slowScroll(page, 200, 1, 900);

  const firstSlider = page.getByRole('slider').first();
  if (await firstSlider.isVisible({ timeout: 3000 }).catch(() => false)) {
    const box = await firstSlider.boundingBox();
    if (box) {
      await page.mouse.click(box.x + box.width * 0.6, box.y + box.height / 2);
      await page.waitForTimeout(800);
      await firstSlider.press('ArrowRight');
      await firstSlider.press('ArrowRight');
      await page.waitForTimeout(600);
    }
  }

  const yesChip = page.getByRole('button', { name: /^Yes$/i }).first();
  if (await yesChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, yesChip);
    await page.waitForTimeout(800);
    const noChip = page.getByRole('button', { name: /^No$/i }).first();
    if (await noChip.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, noChip);
      await page.waitForTimeout(800);
    }
  }

  const nutritionChip = page.getByRole('button', { name: /Nutrition/i }).first();
  if (await nutritionChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, nutritionChip);
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 800);
    await slowScroll(page, 200, 1, 900);
  }

  const housingChip = page.getByRole('button', { name: /Housing/i }).first();
  if (await housingChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, housingChip);
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 800);
    await slowScroll(page, 250, 1, 900);
    const firstChoice = page.getByRole('button', { name: /Shelter|Transitional|Permanent/i }).first();
    if (await firstChoice.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, firstChoice);
      await page.waitForTimeout(800);
    }
  }
  await page.waitForTimeout(1200);

  // ── 4: Log Today (save entries) ────────────────────────────────────────
  const physicalChip = page.getByRole('button', { name: /Physical Health/i }).first();
  if (await physicalChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, physicalChip);
    await page.waitForTimeout(1000);
  }
  await slowScroll(page, -300, 1, 900);

  const saveEntriesBtn = page.getByRole('button', { name: /Save Entries/i }).first();
  if (await saveEntriesBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, saveEntriesBtn);
    await page.waitForTimeout(3000);
  }
  await page.waitForTimeout(1500);

  // ── 6: Baseline — navigate away first so Flutter re-bootstraps health-tracking
  // (same-URL goto is a no-op for Flutter's router; we need a real navigation)
  await goToAppRoute(page, '/participant/dashboard', 500);
  await goToAppRoute(page, '/participant/health-tracking', 2000);
  await page.waitForTimeout(1500);

  const baselineBanner = page.getByRole('button', { name: /record.*baseline|baseline.*snapshot/i }).first();
  if (await baselineBanner.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, baselineBanner);
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 150, 1, 900);

    const baselineSlider = page.getByRole('slider').first();
    if (await baselineSlider.isVisible({ timeout: 3000 }).catch(() => false)) {
      const box2 = await baselineSlider.boundingBox();
      if (box2) {
        await page.mouse.click(box2.x + box2.width * 0.7, box2.y + box2.height / 2);
        await page.waitForTimeout(600);
      }
    }
    const baselineYes = page.getByRole('button', { name: /^Yes$/i }).first();
    if (await baselineYes.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, baselineYes);
      await page.waitForTimeout(800);
    }
    await slowScroll(page, 250, 2, 900);

    const saveBaselineBtn = page.getByRole('button', { name: /save/i }).first();
    if (await saveBaselineBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, saveBaselineBtn);
      await page.waitForTimeout(2500);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 7 — Surveys List
  // ══════════════════════════════════════════════════════════════════════
  await clickButton(page, 'Surveys');
  await page.waitForURL('**/participant/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 260, 1, 900);

  // Resume an in-progress survey
  const resumeBtn = page.getByRole('button', { name: 'Resume Survey' }).first();
  if (await resumeBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, resumeBtn);
    await page.waitForURL(/\/participant\/surveys\/\d+$/, { timeout: 15000 });
    await waitForFlutter(page, 1500);

    const numericInputs = page.locator('input[data-semantics-role="text-field"], textarea');
    if (await numericInputs.count()) {
      await clickLocator(page, numericInputs.first());
      await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
      await page.keyboard.press('Backspace');
      await numericInputs.first().pressSequentially('5', { delay: 80 });
      await page.waitForTimeout(700);
    }
    await slowScroll(page, 300, 1, 900);
    await page.waitForTimeout(800);

    await goToAppRoute(page, '/participant/surveys', 1200);
    await page.waitForURL('**/participant/surveys', { timeout: 15000 });
    await waitForFlutter(page, 1200);
  }

  // Start a new survey
  const startBtn = page.getByRole('button', { name: 'Start Survey' }).first();
  if (await startBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, startBtn);
    await page.waitForURL(/\/participant\/surveys\/\d+$/, { timeout: 15000 });
    await waitForFlutter(page, 1500);

    const yesButton = page.getByRole('button', { name: /^Yes$/i }).first();
    if (await yesButton.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, yesButton);
      await page.waitForTimeout(900);
    } else {
      const firstRadio = page.getByRole('radio').first();
      if (await firstRadio.isVisible({ timeout: 3000 }).catch(() => false)) {
        await clickLocator(page, firstRadio);
        await page.waitForTimeout(900);
      }
    }
    await slowScroll(page, 420, 1, 1100);
    await goToAppRoute(page, '/participant/surveys', 1200);
    await waitForFlutter(page, 1200);
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 8 — Results & Comparison
  // ══════════════════════════════════════════════════════════════════════
  await clickLocator(page, page.getByRole('button', { name: 'Results' }).first());
  await page.waitForURL('**/participant/results', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  const surveyResultBtn = page.getByRole('button', { name: /Q1 2026 Health Assessment/ }).first();
  if (await surveyResultBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, surveyResultBtn);
    await page.waitForTimeout(1500);

    const switches = page.getByRole('switch');
    if (await switches.count()) {
      await clickLocator(page, switches.nth(0));
      await page.waitForTimeout(1800);
    }
    if ((await switches.count()) > 1) {
      await clickLocator(page, switches.nth(1));
      await page.waitForTimeout(1800);
    }
    await slowScroll(page, 420, 2, 1100);
    await slowScroll(page, -420, 1, 900);
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 9 — Messaging
  // ══════════════════════════════════════════════════════════════════════
  await clickLocator(page, page.getByRole('button', { name: 'Messages' }).first());
  await waitForHash(page, '/messages');
  await waitForFlutter(page, 1500);

  // Accept a contact request if pending
  const contactRequestsTab = page.getByRole('button', { name: 'Contact Requests' }).first();
  if (await contactRequestsTab.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, contactRequestsTab);
    await waitForFlutter(page, 1200);
    const acceptContact = page.getByRole('button', { name: 'Accept' }).first();
    if (await acceptContact.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, acceptContact);
      await page.waitForTimeout(2200);
    }
  }

  // Send a message
  const hcpThread = page.getByRole('button', { name: /HCP User/i }).first();
  if (await hcpThread.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, hcpThread);
  } else {
    const anyThread = page.getByText('HCP User', { exact: false }).first();
    if (await anyThread.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, anyThread);
    }
  }
  await page.waitForTimeout(1200);

  const composer = page.getByRole('textbox', { name: /Type a message/i }).first();
  if (await composer.isVisible({ timeout: 3000 }).catch(() => false)) {
    await composer.click();
    await composer.fill('Hello, just checking in after completing my latest survey.');
    await page.waitForTimeout(500);
    const sendBtn = page.getByRole('button', { name: /^Send(?:\s+Send)?$/i }).first();
    if (await sendBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, sendBtn);
      await page.waitForTimeout(2200);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 10 — Language Options
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/participant/dashboard', 1200);
  await selectAccountMenuItem(page, 'Français');
  await page.waitForTimeout(2200);
  await selectAccountMenuItem(page, 'English');
  await page.waitForTimeout(2200);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 11 — Edit Profile
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/profile', 1500);
  await waitForHash(page, '/profile');
  await waitForFlutter(page, 1500);

  const editBtn = page.getByRole('button', { name: 'Edit' }).first();
  if (await editBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, editBtn);
    await page.waitForTimeout(1000);
    await fillField(page, 'First Name', 'Participant Demo');
    await page.waitForTimeout(500);
    const saveChangesBtn = page.getByRole('button', { name: /Save changes/i }).first();
    if (await saveChangesBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, saveChangesBtn);
      await page.waitForTimeout(2400);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 12 — Settings: Appearance & Themes
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/settings', 1500);
  await waitForHash(page, '/settings');
  await waitForFlutter(page, 1500);

  // Browse themes without applying (applying triggers a full re-render)
  await clickText(page, 'Modern');
  await page.waitForTimeout(1200);
  await clickText(page, 'Dark');
  await page.waitForTimeout(1200);
  await clickText(page, 'Modern');
  await page.waitForTimeout(800);

  const applyBtn = page.getByRole('button', { name: /Apply/i }).first();
  if (await applyBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await applyBtn.hover();
    await page.waitForTimeout(1000);
  }
  await slowScroll(page, 220, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 13 — Settings: Security
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/change-password', 1200);
  await waitForHash(page, '/change-password');
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1800);

  await goToAppRoute(page, '/settings', 1200);
  await waitForHash(page, '/settings');
  await waitForFlutter(page, 1200);

  const disable2faButton = page.getByRole('button', { name: /Disable 2FA/i }).first();
  if (await disable2faButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, disable2faButton);
    await page.waitForTimeout(1000);
    const cancelBtn2fa = page.getByRole('button', { name: /Cancel/i }).first();
    if (await cancelBtn2fa.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, cancelBtn2fa);
      await page.waitForTimeout(1000);
    }
  }

  const deleteAccountBtn = page.getByRole('button', { name: /Delete Account/i }).first();
  if (await deleteAccountBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, deleteAccountBtn);
    await page.waitForTimeout(1000);
    const cancelDeleteBtn = page.getByRole('button', { name: /Cancel/i }).last();
    if (await cancelDeleteBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, cancelDeleteBtn);
      await page.waitForTimeout(1200);
    }
  }

  await page.waitForTimeout(2000);
});
