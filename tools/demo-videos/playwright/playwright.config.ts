import { defineConfig, devices } from '@playwright/test';

const defaultRunLabel = new Date().toISOString().replace(/[:.]/g, '-');
const runLabel = process.env.PLAYWRIGHT_RUN_LABEL ?? defaultRunLabel;
const outputDir = process.env.PLAYWRIGHT_OUTPUT_DIR ?? `../output/web/${runLabel}`;

export default defineConfig({
  testDir: './flows',
  // Run flows sequentially — one clean video per flow
  workers: 1,
  fullyParallel: false,
  reporter: 'list',
  outputDir,
  preserveOutput: 'always',
  timeout: 180000,

  use: {
    // Built Flutter web app served locally for stable Playwright demos.
    // Launch via `make demo-web-server`.
    baseURL: 'http://localhost:62582',
    // Record every test as an MP4
    video: {
      mode: 'on',
      size: { width: 1280, height: 800 },
    },
    // Keep app interactions responsive; visible pacing is handled by helper motion/scroll.
    actionTimeout: 15000,
    navigationTimeout: 30000,
    // Full viewport for desktop-style recording
    viewport: { width: 1280, height: 800 },
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});
