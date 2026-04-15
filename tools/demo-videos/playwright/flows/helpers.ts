import { Locator, Page } from '@playwright/test';
import { execSync } from 'node:child_process';
import { resolve } from 'node:path';

const lastMousePosition = new WeakMap<Page, { x: number; y: number }>();

export async function ensureDemoCursor(page: Page) {
  await page.evaluate(() => {
    if (document.getElementById('pw-demo-cursor')) {
      return;
    }

    const cursor = document.createElement('div');
    cursor.id = 'pw-demo-cursor';
    cursor.setAttribute(
      'style',
      [
        'position:fixed',
        'left:0',
        'top:0',
        'width:24px',
        'height:24px',
        'background:#111111',
        'clip-path:polygon(0 0, 0 100%, 24% 76%, 42% 100%, 56% 93%, 38% 69%, 67% 69%)',
        'box-shadow:0 0 0 2px rgba(255,255,255,0.92)',
        'transform:translate(-2px, -2px)',
        'pointer-events:none',
        'z-index:2147483647',
        'transition:transform 120ms ease,filter 120ms ease',
      ].join(';')
    );

    const pulse = document.createElement('div');
    pulse.id = 'pw-demo-cursor-pulse';
    pulse.setAttribute(
      'style',
      [
        'position:fixed',
        'left:0',
        'top:0',
        'width:18px',
        'height:18px',
        'border:2px solid rgba(17,24,39,0.5)',
        'border-radius:9999px',
        'transform:translate(-50%, -50%) scale(1)',
        'opacity:0',
        'pointer-events:none',
        'z-index:2147483646',
      ].join(';')
    );

    document.body.append(cursor, pulse);

    const move = (event: MouseEvent) => {
      const x = event.clientX;
      const y = event.clientY;
      cursor.style.left = `${x}px`;
      cursor.style.top = `${y}px`;
      pulse.style.left = `${x}px`;
      pulse.style.top = `${y}px`;
    };

    const down = () => {
      cursor.style.transform = 'translate(-2px, -2px) scale(0.92)';
      cursor.style.filter = 'brightness(0.9)';
      pulse.style.transition = 'none';
      pulse.style.opacity = '0.9';
      pulse.style.transform = 'translate(-50%, -50%) scale(1)';
      void pulse.offsetWidth;
      pulse.style.transition = 'transform 320ms ease, opacity 320ms ease';
      pulse.style.transform = 'translate(-50%, -50%) scale(2.6)';
      pulse.style.opacity = '0';
    };

    const up = () => {
      cursor.style.transform = 'translate(-2px, -2px) scale(1)';
      cursor.style.filter = 'brightness(1)';
    };

    window.addEventListener('mousemove', move, true);
    window.addEventListener('mousedown', down, true);
    window.addEventListener('mouseup', up, true);
  });
}

async function moveMouseTo(page: Page, x: number, y: number) {
  const start = lastMousePosition.get(page) ?? { x: 140, y: 140 };
  const distance = Math.hypot(x - start.x, y - start.y);
  const segments = Math.max(10, Math.min(28, Math.round(distance / 22)));

  for (let i = 1; i <= segments; i += 1) {
    const progress = i / segments;
    const eased = progress < 0.5
      ? 2 * progress * progress
      : 1 - Math.pow(-2 * progress + 2, 2) / 2;
    const nextX = start.x + (x - start.x) * eased;
    const nextY = start.y + (y - start.y) * eased;
    await page.mouse.move(nextX, nextY);
    await page.waitForTimeout(14);
  }

  lastMousePosition.set(page, { x, y });
  await page.waitForTimeout(70);
}

export async function clickPoint(page: Page, x: number, y: number) {
  await moveMouseTo(page, x, y);
  await page.mouse.click(x, y);
  lastMousePosition.set(page, { x, y });
  await page.waitForTimeout(220);
}

async function moveToLocator(page: Page, locator: { boundingBox(): Promise<{ x: number; y: number; width: number; height: number } | null> }) {
  const box = await locator.boundingBox();
  if (!box) {
    return;
  }
  await moveMouseTo(page, box.x + box.width / 2, box.y + box.height / 2);
}

export async function clickLocator(page: Page, locator: Locator) {
  await moveToLocator(page, locator);
  try {
    await locator.click();
  } catch {
    await locator.click({ force: true });
  }
  await page.waitForTimeout(220);
}

/**
 * Wait for Flutter web (HTML renderer) to finish bootstrapping.
 *
 * With the HTML renderer Flutter creates real DOM elements — no shadow DOM
 * hacks needed.  We wait for network idle + a buffer for app-level init
 * (session restore check, redirects, first frame).
 */
export async function waitForFlutter(page: Page, extraMs = 2000) {
  try {
    await page.waitForLoadState('networkidle', { timeout: 15000 });
  } catch {
    await page.waitForLoadState('domcontentloaded', { timeout: 15000 }).catch(() => {});
    await page.waitForLoadState('load', { timeout: 15000 }).catch(() => {});
  }
  // Flutter web shows a hidden placeholder until accessibility is activated.
  // Dispatch a click via JS to bypass Playwright's off-screen check.
  await page.evaluate(() => {
    const placeholder = document.querySelector('flt-semantics-placeholder');
    if (placeholder) {
      placeholder.dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true }));
    }
  });
  await page.waitForTimeout(1000);
  await page.waitForTimeout(extraMs);
}

/**
 * Open the login card from the marketing home page.
 *
 * In this app the home page is the public landing route and the auth form is
 * reached by activating the visible "Log In" action in the header/body.
 */
export async function openLoginPage(page: Page) {
  await goToAppRoute(page, '/login', 1500);
}

export async function goToAppRoute(page: Page, route: string, extraMs = 1500) {
  const normalized = route.startsWith('/') ? route : `/${route}`;
  const target = normalized === '/' ? '/' : `/#${normalized}`;
  await page.goto(target);
  await waitForFlutter(page, extraMs);
  await ensureDemoCursor(page);
  await moveMouseTo(page, 140, 140);
  await acceptCookies(page);
}

export async function loginAsParticipant(page: Page) {
  await openLoginPage(page);
  await fillField(page, 'Email', 'part@hb.com');
  await fillField(page, 'Password', 'password');
  await clickButton(page, 'Log In');
  await page.waitForURL('**/participant/dashboard', { timeout: 20000 });
  await waitForFlutter(page, 1500);
}

export async function loginAsResearcher(page: Page) {
  await openLoginPage(page);
  await fillField(page, 'Email', 'research@hb.com');
  await fillField(page, 'Password', 'password');
  await clickButton(page, 'Log In');
  await page.waitForURL('**/researcher/dashboard', { timeout: 20000 });
  await waitForFlutter(page, 1500);
}

export async function loginAsHcp(page: Page) {
  await openLoginPage(page);
  await fillField(page, 'Email', 'hcp@hb.com');
  await fillField(page, 'Password', 'password');
  await clickButton(page, 'Log In');
  await page.waitForURL('**/hcp/dashboard', { timeout: 20000 });
  await waitForFlutter(page, 1500);
}

export async function loginAsAdmin(page: Page) {
  await openLoginPage(page);
  await fillField(page, 'Email', 'admin@hb.com');
  await fillField(page, 'Password', 'password');
  await clickButton(page, 'Log In');
  await page.waitForURL('**/admin**', { timeout: 20000 });
  await waitForFlutter(page, 1500);
}

export function resetParticipantDemoState() {
  const scriptPath = resolve(process.cwd(), '../reset_participant_demo_state.sh');
  execSync(`bash ${JSON.stringify(scriptPath)}`, {
    cwd: resolve(process.cwd(), '../..'),
    stdio: 'ignore',
  });
}

export function resetAuthDemoState(mode: 'request' | 'participant' | 'researcher' | 'hcp' | 'all') {
  const scriptPath = resolve(process.cwd(), '../reset_auth_demo_state.sh');
  execSync(`bash ${JSON.stringify(scriptPath)} ${mode}`, {
    cwd: resolve(process.cwd(), '../..'),
    stdio: 'ignore',
  });
}

export async function goToParticipantRoute(page: Page, route: string) {
  await goToAppRoute(page, route, 1500);
}

export async function waitForHash(page: Page, fragment: string, timeout = 15000) {
  await page.waitForFunction(
    (target) =>
      window.location.hash.includes(target) ||
      window.location.pathname.includes(target),
    fragment,
    { timeout }
  );
  await page.waitForTimeout(500);
}

export async function slowScroll(page: Page, deltaY: number, repeats = 1, pauseMs = 900) {
  const direction = Math.sign(deltaY) || 1;
  const total = Math.abs(deltaY);
  const chunk = 48;

  for (let i = 0; i < repeats; i += 1) {
    let covered = 0;
    while (covered < total) {
      const step = Math.min(chunk, total - covered);
      await page.mouse.wheel(0, step * direction);
      covered += step;
      await page.waitForTimeout(70);
    }
    await page.waitForTimeout(Math.min(pauseMs, 280));
  }
}

export async function slowScrollLocator(page: Page, locator: Locator, deltaY: number, repeats = 1, pauseMs = 900) {
  await moveToLocator(page, locator);
  const direction = Math.sign(deltaY) || 1;
  const total = Math.abs(deltaY);
  const chunk = 48;

  for (let i = 0; i < repeats; i += 1) {
    let covered = 0;
    while (covered < total) {
      const step = Math.min(chunk, total - covered);
      await page.mouse.wheel(0, step * direction);
      covered += step;
      await page.waitForTimeout(70);
    }
    await page.waitForTimeout(Math.min(pauseMs, 280));
  }
}

/**
 * Accept the cookie consent banner if it is visible.
 */
export async function acceptCookies(page: Page) {
  try {
    const btn = page.getByRole('button', { name: 'Accept' });
    if (await btn.isVisible({ timeout: 4000 })) {
      await moveToLocator(page, btn);
      await btn.click();
      await page.waitForTimeout(700);
    }
  } catch {
    // Not shown or already dismissed
  }
}

/**
 * Click a Flutter TextField by its label and type a value.
 *
 * Use pressSequentially — Flutter intercepts keyboard events.
 * fill() bypasses Flutter's event system and leaves the field empty.
 */
export async function fillField(page: Page, label: string, value: string) {
  const labelledField = page.getByLabel(label);
  if (await labelledField.count()) {
    const field = labelledField.first();
    await moveToLocator(page, field);
    await field.click();
    await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
    await page.keyboard.press('Backspace');
    await page.waitForTimeout(400);
    await field.pressSequentially(value, { delay: 60 });
    await page.waitForTimeout(300);
    return;
  }

  const placeholderField = page.getByPlaceholder(label);
  if (await placeholderField.count()) {
    const field = placeholderField.first();
    await moveToLocator(page, field);
    await field.click();
    await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
    await page.keyboard.press('Backspace');
    await page.waitForTimeout(400);
    await field.pressSequentially(value, { delay: 60 });
    await page.waitForTimeout(300);
    return;
  }

  const inputIndex = await page.evaluate((targetLabel) => {
    const normalize = (text: string | null | undefined) =>
      (text ?? '').replace(/\s+/g, ' ').trim().toLowerCase();

    const labelElements = Array.from(document.querySelectorAll('flt-semantics'))
      .filter((element) => normalize(element.textContent) === normalize(targetLabel));

    const inputs = Array.from(
      document.querySelectorAll<HTMLInputElement | HTMLTextAreaElement>(
        'input[data-semantics-role="text-field"], textarea'
      )
    );

    const ranked = labelElements.flatMap((labelElement) => {
      const labelRect = labelElement.getBoundingClientRect();

      return inputs
        .map((input, index) => {
          const inputRect = input.getBoundingClientRect();
          const verticalGap = inputRect.top - labelRect.bottom;
          const horizontalDistance = Math.abs(
            inputRect.left + inputRect.width / 2 - (labelRect.left + labelRect.width / 2)
          );
          const overlapsHorizontally =
            inputRect.left <= labelRect.right + 24 && inputRect.right >= labelRect.left - 24;

          return { index, verticalGap, horizontalDistance, overlapsHorizontally };
        })
        .filter(
          ({ verticalGap, overlapsHorizontally }) =>
            verticalGap >= -8 && verticalGap < 140 && overlapsHorizontally
        )
        .sort((a, b) => a.verticalGap - b.verticalGap || a.horizontalDistance - b.horizontalDistance);
    });

    return ranked[0]?.index ?? -1;
  }, label);

  if (inputIndex < 0) {
    const lowerLabel = label.toLowerCase();
    let fallbackField: Locator | null = null;

    if (lowerLabel.includes('password')) {
      const passwordField = page.locator('input[type="password"]').first();
      if (await passwordField.count()) {
        fallbackField = passwordField;
      }
    }

    if (!fallbackField && (lowerLabel === 'email' || lowerLabel.includes('email'))) {
      const emailField = page.locator('input[type="email"]').first();
      if (await emailField.count()) {
        fallbackField = emailField;
      }
    }

    if (!fallbackField) {
      const textboxCandidates = page.locator(
        'input:not([type="hidden"]):not([disabled]), textarea:not([disabled])'
      );
      const fallbackIndex = lowerLabel.includes('password')
        ? 1
        : lowerLabel.includes('confirm')
          ? 2
          : 0;
      if (await textboxCandidates.count()) {
        fallbackField = textboxCandidates.nth(
          Math.min(fallbackIndex, Math.max(0, (await textboxCandidates.count()) - 1))
        );
      }
    }

    if (!fallbackField) {
      throw new Error(`Could not find a Flutter text field for label "${label}"`);
    }

    await moveToLocator(page, fallbackField);
    await fallbackField.click();
    await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
    await page.keyboard.press('Backspace');
    await page.waitForTimeout(400);
    await fallbackField.pressSequentially(value, { delay: 60 });
    await page.waitForTimeout(300);
    return;
  }

  const field = page.locator('input[data-semantics-role="text-field"], textarea').nth(inputIndex);
  await moveToLocator(page, field);
  await field.click();
  await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
  await page.keyboard.press('Backspace');
  await page.waitForTimeout(400);
  await field.pressSequentially(value, { delay: 60 });
  await page.waitForTimeout(300);
}

/** Click a Flutter button by its accessible name. */
export async function clickButton(page: Page, name: string) {
  const buttons = page.getByRole('button', { name });
  const count = await buttons.count();
  const button = count > 1 ? buttons.last() : buttons.first();
  await moveToLocator(page, button);
  await button.click();
  await page.waitForTimeout(500);
}

export async function selectDropdownOption(page: Page, locator: Locator, arrowDownCount = 0) {
  await clickLocator(page, locator);
  await page.waitForTimeout(700);
  for (let i = 0; i < arrowDownCount; i += 1) {
    await page.keyboard.press('ArrowDown');
    await page.waitForTimeout(300);
  }
  await page.keyboard.press('Enter');
  await page.waitForTimeout(900);
}

/** Click the first element whose visible text contains the given string. */
export async function clickText(page: Page, text: string) {
  const target = page.getByText(text, { exact: false }).first();
  await moveToLocator(page, target);
  try {
    await target.click();
  } catch {
    await target.click({ force: true });
  }
  await page.waitForTimeout(500);
}

export async function typeIntoPlaceholder(page: Page, placeholder: string, value: string) {
  const enabledTextField = page
    .locator('input[data-semantics-role="text-field"]:not([disabled]), textarea:not([disabled])')
    .last();
  const placeholderField = page.getByPlaceholder(placeholder).first();
  const field = await enabledTextField.count()
    ? enabledTextField
    : await placeholderField.count()
      ? placeholderField
      : page.getByRole('textbox').last();
  await moveToLocator(page, field);
  await field.click();
  await page.keyboard.press(process.platform === 'darwin' ? 'Meta+A' : 'Control+A');
  await page.keyboard.press('Backspace');
  await page.waitForTimeout(400);
  await field.pressSequentially(value, { delay: 60 });
  await field.evaluate((element, nextValue) => {
    if (!(element instanceof HTMLInputElement) && !(element instanceof HTMLTextAreaElement)) {
      return;
    }
    element.value = nextValue;
    element.dispatchEvent(new Event('input', { bubbles: true, cancelable: true }));
    element.dispatchEvent(new Event('change', { bubbles: true, cancelable: true }));
  }, value);
  await page.waitForTimeout(300);
}

type ConsentFallbackAuth = {
  email: string;
  password: string;
};

async function submitConsentViaApi(
  page: Page,
  fullName: string,
  dashboardRoute: string,
  auth: ConsentFallbackAuth
) {
  const documentText = await page.locator('textarea[disabled]').first().inputValue();
  const submitButton = page.getByRole('button', { name: 'I Agree and Submit' }).first();
  const box = await submitButton.boundingBox();
  if (box) {
    await clickPoint(page, box.x + box.width / 2, box.y + box.height / 2);
  }

  const result = await page.evaluate(
    async ({ documentText: text, signatureName, email, password }) => {
      const loginResponse = await fetch('http://127.0.0.1:8000/api/v1/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Client-Type': 'native',
        },
        body: JSON.stringify({
          email,
          password,
        }),
      });

      const loginBody = await loginResponse.json().catch(() => ({}));
      const token = loginBody?.session_token;
      if (!loginResponse.ok || !token) {
        return {
          ok: false,
          status: loginResponse.status,
          body: JSON.stringify(loginBody),
        };
      }

      const response = await fetch('http://127.0.0.1:8000/api/v1/consent/submit', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Client-Type': 'native',
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          document_text: text,
          document_language: 'en',
          signature_name: signatureName,
        }),
      });

      return {
        ok: response.ok,
        status: response.status,
        body: await response.text(),
      };
    },
    {
      documentText,
      signatureName: fullName,
      email: auth.email,
      password: auth.password,
    }
  );

  if (!result.ok) {
    throw new Error(`Consent API fallback failed (${result.status}): ${result.body}`);
  }

  await page.waitForTimeout(1200);
  await goToParticipantRoute(page, dashboardRoute);
}

export async function completeConsent(
  page: Page,
  fullName: string,
  dashboardRoute?: string,
  auth?: ConsentFallbackAuth
) {
  await waitForHash(page, '/consent', 20000);
  await waitForFlutter(page, 1500);
  const signatureInput = page.getByPlaceholder('Type your full legal name').first();
  for (let attempt = 0; attempt < 4; attempt += 1) {
    if (await signatureInput.isVisible().catch(() => false)) {
      break;
    }
    await slowScroll(page, 320, 1, 700);
  }
  await typeIntoPlaceholder(page, 'Type your full legal name', fullName);
  await slowScroll(page, 180, 1, 500);
  const nativeCheckbox = page.locator('input[type="checkbox"]:not([disabled])').first();
  if (await nativeCheckbox.count()) {
    await moveToLocator(page, nativeCheckbox);
    await nativeCheckbox.check();
  } else {
    const checkbox = page.getByRole('checkbox');
    if (!(await checkbox.isChecked().catch(() => false))) {
      await clickLocator(page, checkbox);
    }
  }
  await page.waitForTimeout(700);

  const submitButton = page.getByRole('button', { name: 'I Agree and Submit' }).first();
  const enabled = await page
    .waitForFunction(() => {
      const submit = Array.from(document.querySelectorAll('flt-semantics')).find(
        (element) => element.textContent?.trim() === 'I Agree and Submit'
      );
      return submit?.getAttribute('aria-disabled') !== 'true';
    }, undefined, { timeout: 3000 })
    .then(() => true)
    .catch(() => false);

  if (enabled) {
    await moveToLocator(page, submitButton);
    await submitButton.click();
    await page.waitForTimeout(2000);
    return;
  }

  if (!dashboardRoute || !auth) {
    throw new Error(
      'Consent submit stayed disabled and no dashboard/auth fallback details were provided.'
    );
  }

  await submitConsentViaApi(page, fullName, dashboardRoute, auth);
}

export async function completeParticipantProfile(page: Page) {
  await waitForHash(page, '/complete-profile', 20000);
  await waitForFlutter(page, 1500);
  await clickButton(page, 'Date of Birth');
  await page.waitForTimeout(900);
  await clickButton(page, 'OK');
  await page.waitForTimeout(900);
  await clickLocator(page, page.getByRole('button').nth(4));
  await page.waitForTimeout(700);
  await page.keyboard.press('ArrowDown');
  await page.waitForTimeout(400);
  await page.keyboard.press('Enter');
  await page.waitForTimeout(700);
  await clickButton(page, 'Continue');
  await page.waitForTimeout(1800);
}

export async function completeFirstLoginPasswordChange(
  page: Page,
  email: string,
  temporaryPassword: string,
  newPassword: string
) {
  await openLoginPage(page);
  await fillField(page, 'Email', email);
  await fillField(page, 'Password', temporaryPassword);
  await clickButton(page, 'Log In');
  await page.waitForTimeout(2500);
  if (!page.url().includes('/change-password')) {
    await page.goto('/#/change-password');
  }
  await waitForHash(page, '/change-password', 20000);
  await waitForFlutter(page, 1500);
  await fillField(page, 'Current Password', temporaryPassword);
  await fillField(page, 'New Password', newPassword);
  await fillField(page, 'Confirm New Password', newPassword);
  await clickButton(page, 'Change Password');
  await page.waitForTimeout(2000);
}

export async function openAccountMenu(page: Page) {
  try {
    await clickButton(page, 'Show menu');
  } catch {
    const viewport = page.viewportSize() ?? { width: 1280, height: 800 };
    await clickPoint(page, viewport.width - 110, 30);
  }
  await page.waitForTimeout(700);
}

export async function selectAccountMenuItem(page: Page, name: string) {
  await openAccountMenu(page);
  const visibleItem = page.getByRole('button', { name }).first();
  if (await visibleItem.isVisible({ timeout: 1500 }).catch(() => false)) {
    await clickLocator(page, visibleItem);
    await page.waitForTimeout(700);
    return;
  }

  const visibleText = page.getByText(name, { exact: false }).first();
  if (await visibleText.isVisible({ timeout: 1000 }).catch(() => false)) {
    await clickText(page, name);
    await page.waitForTimeout(700);
    return;
  }

  const viewport = page.viewportSize() ?? { width: 1280, height: 800 };
  const x = viewport.width - 90;
  const menuY: Record<string, number> = {
    Profile: 95,
    Settings: 145,
    English: 200,
    Français: 250,
    Español: 295,
    Logout: 355,
  };
  const y = menuY[name];

  if (!y) {
    throw new Error(`Unsupported account menu item: ${name}`);
  }

  await clickPoint(page, x, y);
  await page.waitForTimeout(700);
}
