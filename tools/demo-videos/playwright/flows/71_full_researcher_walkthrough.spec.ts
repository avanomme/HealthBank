/**
 * Full Researcher Walkthrough — single login, all use cases in one video.
 *
 * Covers: Dashboard → Survey List → Build Survey (scratch + question bank + template)
 *         → Publish → Assign (all + demographic) → Survey Status & Close
 *         → Templates → Create Template → Question Bank → Messaging
 *         → Research Data (by survey + data bank) → Health Tracking Analytics
 */

import { test } from '@playwright/test';
import {
  clickButton,
  clickLocator,
  fillField,
  goToAppRoute,
  loginAsResearcher,
  selectDropdownOption,
  slowScroll,
  waitForFlutter,
} from './helpers';

test('Researcher: Full Walkthrough', async ({ page }) => {
  test.setTimeout(600000);

  // ── Login ────────────────────────────────────────────────────────────────
  await loginAsResearcher(page);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 1 — Dashboard
  // ══════════════════════════════════════════════════════════════════════
  await page.waitForTimeout(2500);
  await slowScroll(page, 400, 2, 1200);
  await slowScroll(page, -400, 1, 1000);

  const expandBtn = page.getByRole('button', { name: 'Expand sidebar' });
  if (await expandBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await expandBtn.click();
    await page.waitForTimeout(900);
  }
  await slowScroll(page, 600, 2, 1100);
  await slowScroll(page, -600, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 2 — Survey List & Filters
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 900);

  const statusFilter = page.getByRole('button', { name: /Status/ }).first();
  if (await statusFilter.isVisible({ timeout: 3000 }).catch(() => false)) {
    await selectDropdownOption(page, statusFilter, 1);
    await page.waitForTimeout(1200);
    await selectDropdownOption(page, statusFilter, 2);
    await page.waitForTimeout(1200);
    const clearAll = page.getByRole('button', { name: 'Clear All' }).first();
    if (await clearAll.isVisible({ timeout: 2000 }).catch(() => false)) {
      await clearAll.click();
      await page.waitForTimeout(1000);
    }
  }
  await slowScroll(page, -200, 1, 800);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 3 — Build Survey From Scratch
  // ══════════════════════════════════════════════════════════════════════
  await clickButton(page, 'New Survey');
  await waitForFlutter(page, 1500);

  const titleField = page.getByRole('textbox').nth(0);
  await clickLocator(page, titleField);
  await titleField.pressSequentially('Q3 2026 Health Assessment', { delay: 40 });
  await page.waitForTimeout(300);

  const descriptionField = page.getByRole('textbox').nth(1);
  await clickLocator(page, descriptionField);
  await descriptionField.pressSequentially('Third-quarter health check for enrolled participants.', { delay: 35 });
  await page.waitForTimeout(300);

  const addQuestionsBtn = page.getByRole('button', { name: /Add Questions/ }).first();
  if (await addQuestionsBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
    await clickLocator(page, addQuestionsBtn);
    await page.waitForTimeout(800);

    const addNewQuestion = page.getByRole('menuitem', { name: 'Add New Question' }).first();
    if (await addNewQuestion.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, addNewQuestion);
      await page.waitForTimeout(1200);

      const questionInput = page.getByRole('textbox').last();
      if (await questionInput.isVisible({ timeout: 4000 }).catch(() => false)) {
        await questionInput.click();
        await questionInput.pressSequentially('How would you rate your overall health this week?', { delay: 40 });
        await page.waitForTimeout(500);
      }

      const confirmBtn = page.getByRole('button', { name: /confirm/i }).first();
      if (await confirmBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
        await confirmBtn.click();
        await page.waitForTimeout(1500);
      }
    }
  }

  await clickButton(page, 'Save Draft');
  await page.waitForTimeout(1800);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 4 — Build Survey From Question Bank
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1200);
  await clickButton(page, 'New Survey');
  await waitForFlutter(page, 1500);

  const titleField2 = page.getByRole('textbox').nth(0);
  await clickLocator(page, titleField2);
  await titleField2.pressSequentially('Q4 2026 Assessment', { delay: 40 });
  await page.waitForTimeout(300);

  const addQuestionsBtn2 = page.getByRole('button', { name: /Add Questions/ }).first();
  if (await addQuestionsBtn2.isVisible({ timeout: 5000 }).catch(() => false)) {
    await clickLocator(page, addQuestionsBtn2);
    await page.waitForTimeout(800);

    const fromBank = page.getByRole('menuitem', { name: /Question Bank|From Bank/ }).first();
    if (await fromBank.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, fromBank);
      await page.waitForTimeout(1500);
      await waitForFlutter(page, 1000);

      // Select a few questions from the bank
      const checkboxes = page.getByRole('checkbox');
      const total = await checkboxes.count();
      for (let i = 0; i < Math.min(total, 3); i++) {
        const cb = checkboxes.nth(i);
        if (await cb.isVisible({ timeout: 1500 }).catch(() => false)) {
          await cb.click();
          await page.waitForTimeout(400);
        }
      }

      const addSelectedBtn = page.getByRole('button', { name: /Add Selected|Add \(|Done/i }).first();
      if (await addSelectedBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
        await clickLocator(page, addSelectedBtn);
        await page.waitForTimeout(1500);
      }
    }
  }

  await clickButton(page, 'Save Draft');
  await page.waitForTimeout(1800);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 5 — Build Survey From Template
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1200);

  const fromTemplateBtn = page.getByRole('button', { name: /From Template/i }).first();
  if (await fromTemplateBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, fromTemplateBtn);
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);

    const firstTemplate = page.getByRole('button', { name: /Use Template|Select/i }).first();
    if (await firstTemplate.isVisible({ timeout: 4000 }).catch(() => false)) {
      await clickLocator(page, firstTemplate);
      await page.waitForTimeout(1800);
      await waitForFlutter(page, 1200);

      await clickButton(page, 'Save Draft');
      await page.waitForTimeout(1800);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 6 — Publish Survey
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/surveys', 1500);
  await page.waitForURL('**/surveys', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  // Open the first draft survey
  const draftFilter = page.getByRole('button', { name: /Draft/i }).first();
  if (await draftFilter.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, draftFilter);
    await page.waitForTimeout(1200);
  }
  await slowScroll(page, 200, 1, 900);

  const firstDraftCard = page.getByRole('button', { name: /Open|View|Q3 2026/i }).first();
  if (await firstDraftCard.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, firstDraftCard);
    await waitForFlutter(page, 1500);

    const publishBtn = page.getByRole('button', { name: /Publish Survey/i }).first();
    if (await publishBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
      await publishBtn.click();
      await page.waitForTimeout(1000);
      const confirmPublish = page.getByRole('button', { name: /Publish/i }).last();
      if (await confirmPublish.isVisible({ timeout: 2000 }).catch(() => false)) {
        await confirmPublish.click();
        await page.waitForTimeout(2000);
      }
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 7 — Assign Survey (All Participants)
  // ══════════════════════════════════════════════════════════════════════
  const assignAllBtn = page.getByRole('button', { name: /Assign to All/i }).first();
  if (await assignAllBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, assignAllBtn);
    await page.waitForTimeout(1000);
    const confirmAssign = page.getByRole('button', { name: /Assign|Confirm/i }).last();
    if (await confirmAssign.isVisible({ timeout: 2000 }).catch(() => false)) {
      await confirmAssign.click();
      await page.waitForTimeout(2000);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 8 — Assign Survey By Demographic
  // ══════════════════════════════════════════════════════════════════════
  const assignDemoBtn = page.getByRole('button', { name: /Assign by Demographic|Targeted Assign/i }).first();
  if (await assignDemoBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, assignDemoBtn);
    await page.waitForTimeout(1500);
    await waitForFlutter(page, 1000);
    await slowScroll(page, 200, 1, 900);

    const cancelAssign = page.getByRole('button', { name: /Cancel/i }).first();
    if (await cancelAssign.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, cancelAssign);
      await page.waitForTimeout(800);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 9 — Survey Status & Close
  // ══════════════════════════════════════════════════════════════════════
  const surveyStatus = page.getByRole('button', { name: /Survey Status|Lifecycle/i }).first();
  if (await surveyStatus.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, surveyStatus);
    await page.waitForTimeout(1200);
  } else {
    await slowScroll(page, 200, 1, 900);
  }

  const closeBtn = page.getByRole('button', { name: /Close Survey/i }).first();
  if (await closeBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await closeBtn.click();
    await page.waitForTimeout(1000);
    const confirmClose = page.getByRole('button', { name: /Close/i }).last();
    if (await confirmClose.isVisible({ timeout: 2000 }).catch(() => false)) {
      await confirmClose.click();
      await page.waitForTimeout(2000);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 10 — Template Library
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/templates', 1500);
  await page.waitForURL('**/templates', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 2, 1000);
  await slowScroll(page, -300, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 11 — Create New Template
  // ══════════════════════════════════════════════════════════════════════
  const newTemplateBtn = page.getByRole('button', { name: /New Template/i }).first();
  if (await newTemplateBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, newTemplateBtn);
    await waitForFlutter(page, 1500);

    const templateTitle = page.getByRole('textbox').first();
    if (await templateTitle.isVisible({ timeout: 3000 }).catch(() => false)) {
      await templateTitle.click();
      await templateTitle.pressSequentially('Monthly Health Template', { delay: 40 });
      await page.waitForTimeout(500);
    }

    const saveTemplateBtn = page.getByRole('button', { name: /Save Template|Save/i }).first();
    if (await saveTemplateBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
      await clickLocator(page, saveTemplateBtn);
      await page.waitForTimeout(1800);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 12 — Question Bank
  // ══════════════════════════════════════════════════════════════════════
  await clickButton(page, 'Question Bank');
  await page.waitForURL('**/questions', { timeout: 15000 });
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 2, 1000);

  await fillField(page, 'Search', 'health');
  await page.waitForTimeout(1500);
  await slowScroll(page, 200, 1, 800);
  await fillField(page, 'Search', '');
  await page.waitForTimeout(800);

  const addQuestionBankBtn = page.getByRole('button', { name: /New Question/i }).first();
  if (await addQuestionBankBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await addQuestionBankBtn.hover();
    await page.waitForTimeout(700);
  }
  await slowScroll(page, -300, 1, 800);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 13 — Messaging Inbox
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/messages', 1500);
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1200);
  await slowScroll(page, 300, 1, 1000);

  const firstThread = page.getByRole('listitem').first();
  if (await firstThread.isVisible({ timeout: 3000 }).catch(() => false)) {
    await clickLocator(page, firstThread);
    await page.waitForTimeout(1500);
    await slowScroll(page, 200, 1, 900);
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 14 — Research Data: By Survey
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/researcher/data', 1500);
  await page.waitForURL('**/researcher/data', { timeout: 15000 });
  await waitForFlutter(page, 1500);

  const surveyInput = page.getByRole('textbox', { name: 'Select a survey' }).first();
  if (await surveyInput.isVisible({ timeout: 5000 }).catch(() => false)) {
    await clickLocator(page, surveyInput);
    await surveyInput.pressSequentially('Q1 2026', { delay: 35 });
    await page.waitForTimeout(900);
    await page.keyboard.press('ArrowDown');
    await page.waitForTimeout(400);
    await page.keyboard.press('Enter');
    await page.waitForTimeout(1800);
    await waitForFlutter(page, 1800);
  }

  await page.waitForTimeout(1200);
  await slowScroll(page, 200, 1, 900);

  const dataTableTab = page.getByRole('tab', { name: 'Data Table' }).first();
  if (await dataTableTab.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clickLocator(page, dataTableTab);
    await page.waitForTimeout(1000);
    await waitForFlutter(page, 1200);
    await slowScroll(page, 350, 2, 1000);
  }

  const analysisTab = page.getByRole('tab', { name: 'Analysis' }).first();
  if (await analysisTab.isVisible({ timeout: 2000 }).catch(() => false)) {
    await clickLocator(page, analysisTab);
    await page.waitForTimeout(1000);
    await waitForFlutter(page, 1800);
    await page.waitForTimeout(1200);

    const lineBtn = page.getByRole('button', { name: 'Line chart' }).first();
    if (await lineBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
      await clickLocator(page, lineBtn);
      await page.waitForTimeout(1200);
    }
    const barBtn = page.getByRole('button', { name: 'Bar chart' }).first();
    if (await barBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
      await clickLocator(page, barBtn);
      await page.waitForTimeout(1000);
    }
  }
  await slowScroll(page, -400, 1, 900);
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 15 — Research Data: Data Bank Mode
  // ══════════════════════════════════════════════════════════════════════
  const dataBankSegment = page.getByRole('button', { name: 'Data Bank' });
  if (await dataBankSegment.isVisible({ timeout: 4000 }).catch(() => false)) {
    await clickLocator(page, dataBankSegment);
    await page.waitForTimeout(1200);
    await waitForFlutter(page, 1000);

    const addFieldsBtn = page.getByRole('button', { name: 'Add Fields' });
    if (await addFieldsBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
      await addFieldsBtn.click();
      await page.waitForTimeout(1500);
      await waitForFlutter(page, 1000);

      const selectAllBtn = page.getByRole('button', { name: 'Select All' }).first();
      if (await selectAllBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
        await selectAllBtn.click();
        await page.waitForTimeout(800);
      } else {
        const checkboxes = page.getByRole('checkbox');
        for (let i = 0; i < Math.min(await checkboxes.count(), 4); i++) {
          const cb = checkboxes.nth(i);
          if (await cb.isVisible({ timeout: 1500 }).catch(() => false)) {
            await cb.click();
            await page.waitForTimeout(300);
          }
        }
      }

      const doneBtn = page.getByRole('button', { name: /Done|Add Selected|Add \(/ }).first();
      if (await doneBtn.isVisible({ timeout: 4000 }).catch(() => false)) {
        await doneBtn.click();
        await page.waitForTimeout(1500);
      }

      await waitForFlutter(page, 1800);
      await page.waitForTimeout(1200);
      await slowScroll(page, 300, 1, 900);
    }
  }
  await page.waitForTimeout(1500);

  // ══════════════════════════════════════════════════════════════════════
  // SECTION 16 — Health Tracking Analytics
  // ══════════════════════════════════════════════════════════════════════
  await goToAppRoute(page, '/researcher/health-tracking', 1500);
  await waitForFlutter(page, 1500);
  await page.waitForTimeout(1800);

  const categoryDropdown = page.getByRole('combobox').first();
  if (await categoryDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await selectDropdownOption(page, categoryDropdown, 1);
    await page.waitForTimeout(1200);
  }

  const metricDropdown = page.getByRole('combobox').nth(1);
  if (await metricDropdown.isVisible({ timeout: 5000 }).catch(() => false)) {
    await selectDropdownOption(page, metricDropdown, 1);
    await page.waitForTimeout(1500);
  }

  await waitForFlutter(page, 1200);
  await slowScroll(page, 300, 2, 900);

  const exportCsvBtn = page.getByRole('button', { name: /Export CSV|Export/i }).first();
  if (await exportCsvBtn.isVisible({ timeout: 3000 }).catch(() => false)) {
    await exportCsvBtn.hover();
    await page.waitForTimeout(800);
  }

  await slowScroll(page, -400, 1, 800);
  await page.waitForTimeout(2000);
});
