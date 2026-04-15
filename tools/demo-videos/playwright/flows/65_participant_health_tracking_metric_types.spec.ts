import { test } from '@playwright/test';
import {
  clickLocator,
  ensureDemoCursor,
  goToAppRoute,
  loginAsParticipant,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Participant: Health Tracking — Metric Input Types', async ({ page }) => {
  await loginAsParticipant(page);

  await goToAppRoute(page, '/participant/health-tracking', 1500);
  await waitForFlutter(page, 1500);
  await ensureDemoCursor(page);

  await page.waitForTimeout(1800);

  // ── Scale metric (slider) ──────────────────────────────────────────────────
  // Physical Health category is loaded by default — contains scale metrics
  await slowScroll(page, 200, 1, 900);
  await page.waitForTimeout(1000);

  const firstSlider = page.getByRole('slider').first();
  if (await firstSlider.isVisible({ timeout: 3000 }).catch(() => false)) {
    const box = await firstSlider.boundingBox();
    if (box) {
      // Click at 60% along the slider
      await page.mouse.click(box.x + box.width * 0.6, box.y + box.height / 2);
      await page.waitForTimeout(800);
      // Move further right via keyboard
      await firstSlider.press('ArrowRight');
      await firstSlider.press('ArrowRight');
      await page.waitForTimeout(600);
    }
  }

  // ── Yes/No metric (chip buttons) ──────────────────────────────────────────
  const yesChip = page.getByRole('button', { name: /^Yes$/i }).first();
  if (await yesChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, yesChip);
    await page.waitForTimeout(800);
    // Toggle to No
    const noChip = page.getByRole('button', { name: /^No$/i }).first();
    if (await noChip.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clickLocator(page, noChip);
      await page.waitForTimeout(800);
    }
  }

  // ── Scroll to Nutrition category for number input (meals / glasses) ────────
  const nutritionChip = page.getByRole('button', { name: /Nutrition/i }).first();
  if (await nutritionChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, nutritionChip);
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 800);
  }

  await slowScroll(page, 200, 1, 900);
  await page.waitForTimeout(800);

  // ── Number input field ─────────────────────────────────────────────────────
  const numberInput = page.getByRole('spinbutton').first();
  if (await numberInput.isVisible({ timeout: 3000 }).catch(() => false)) {
    await numberInput.click();
    await numberInput.fill('3');
    await page.waitForTimeout(800);
  } else {
    // Fallback: look for a text field with a number placeholder
    const textInput = page.getByRole('textbox').first();
    if (await textInput.isVisible({ timeout: 2000 }).catch(() => false)) {
      await textInput.click();
      await textInput.fill('3');
      await page.waitForTimeout(800);
    }
  }

  // ── Housing Stability category — single-choice dropdown ───────────────────
  const housingChip = page.getByRole('button', { name: /Housing/i }).first();
  if (await housingChip.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, housingChip);
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 800);

    await slowScroll(page, 200, 1, 900);
    await page.waitForTimeout(600);

    const choiceDropdown = page.getByRole('combobox').first();
    if (await choiceDropdown.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, choiceDropdown);
      await page.waitForTimeout(800);
      const firstChoice = page.getByRole('option').first();
      if (await firstChoice.isVisible({ timeout: 2000 }).catch(() => false)) {
        await clickLocator(page, firstChoice);
        await page.waitForTimeout(800);
      }
    }
  }

  // ── Save all filled entries ────────────────────────────────────────────────
  await page.keyboard.press('End');
  await page.waitForTimeout(600);

  const saveButton = page.getByRole('button', { name: /save/i }).first();
  if (await saveButton.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, saveButton);
    await page.waitForTimeout(2500);
  }

  await waitForFlutter(page, 800);
});
