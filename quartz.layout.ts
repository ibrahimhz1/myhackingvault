import { PageLayout, SharedLayout } from "./quartz/cfg"
import * as Component from "./quartz/components"

/**
 * LAYOUT CONFIGURATION
 * =====================
 * Controls which components appear in the sidebar, header, and footer.
 * Edit this file to add/remove/reorder UI components.
 *
 * Docs: https://quartz.jzhao.xyz/layout
 */

// Components that appear on ALL pages (header, footer)
export const sharedPageComponents: SharedLayout = {
  head: Component.Head(),
  header: [],
  afterBody: [
    // Uncomment to add Giscus comments to all published notes:
    // Component.Comments({
    //   provider: "giscus",
    //   options: {
    //     repo: "YOUR_USERNAME/your-site",
    //     repoId: "YOUR_REPO_ID",
    //     category: "Announcements",
    //     categoryId: "YOUR_CATEGORY_ID",
    //   },
    // }),
  ],
  footer: Component.Footer({
    links: {
      GitHub: "https://github.com/YOUR_USERNAME",
      RSS: "/index.xml",
    },
  }),
}

// Default layout for content pages (notes, folders, tag pages)
export const defaultContentPageLayout: PageLayout = {
  beforeBody: [
    Component.Breadcrumbs(),
    Component.ArticleTitle(),
    Component.ContentMeta(),
    Component.TagList(),
  ],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Search(),
    Component.Darkmode(),
    Component.DesktopOnly(Component.Explorer()),
  ],
  right: [
    Component.Graph({
      localGraph: {
        depth: 2,
        showTags: true,
      },
      globalGraph: {
        showTags: true,
      },
    }),
    Component.DesktopOnly(Component.TableOfContents()),
    Component.Backlinks(),
  ],
}

// Layout for folder index pages
export const defaultListPageLayout: PageLayout = {
  beforeBody: [
    Component.Breadcrumbs(),
    Component.ArticleTitle(),
    Component.ContentMeta(),
  ],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Search(),
    Component.Darkmode(),
    Component.DesktopOnly(Component.Explorer()),
  ],
  right: [],
}
