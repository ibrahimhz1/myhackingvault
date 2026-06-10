// quartz.ts
// ─────────────────────────────────────────────────────────────
// Quartz v5 entry point.
// Config lives in quartz.config.yaml — edit that file.
// This file only needs to change if you have advanced TypeScript
// overrides (custom sort functions, callback-based plugin options).
// ─────────────────────────────────────────────────────────────
import { loadQuartzConfig, loadQuartzLayout } from "./quartz/plugins/loader/config-loader"

const config = await loadQuartzConfig()
export default config
export const layout = await loadQuartzLayout()
