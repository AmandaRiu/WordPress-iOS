import UIKit

@objc
class MySitesCoordinator: NSObject {
    let mySiteSplitViewController: WPSplitViewController
    let mySiteNavigationController: UINavigationController
    let blogListViewController: BlogListViewController

    @objc
    init(mySiteSplitViewController: WPSplitViewController,
         mySiteNavigationController: UINavigationController,
         blogListViewController: BlogListViewController) {
        self.mySiteSplitViewController = mySiteSplitViewController
        self.mySiteNavigationController = mySiteNavigationController
        self.blogListViewController = blogListViewController

        super.init()
    }

    private func prepareToNavigate() {
        WPTabBarController.sharedInstance().showMySitesTab()

        mySiteNavigationController.viewControllers = [blogListViewController]
    }

    func showMySites() {
        prepareToNavigate()
    }

    func showBlogDetails(for blog: Blog, then subsection: BlogDetailsSubsection? = nil) {
        prepareToNavigate()

        blogListViewController.setSelectedBlog(blog, animated: false)

        if let subsection = subsection,
            let mySiteViewController = mySiteNavigationController.topViewController as? MySiteViewController {
            mySiteViewController.showDetailView(for: subsection)
        }
    }

    // MARK: - Stats

    func showStats(for blog: Blog) {
        showBlogDetails(for: blog, then: .stats)
    }

    func showStats(for blog: Blog, timePeriod: StatsPeriodType) {
        showBlogDetails(for: blog)

        if let mySiteViewController = mySiteNavigationController.topViewController as? MySiteViewController {
            // Setting this user default is a bit of a hack, but it's by far the easiest way to
            // get the stats view controller displaying the correct period. I spent some time
            // trying to do it differently, but the existing stats view controller setup is
            // quite complex and contains many nested child view controllers. As we're planning
            // to revamp that section in the not too distant future, I opted for this simpler
            // configuration for now. 2018-07-11 @frosty
            UserDefaults.standard.set(timePeriod.rawValue, forKey: MySitesCoordinator.statsPeriodTypeDefaultsKey)

            mySiteViewController.showDetailView(for: .stats)
        }
    }

    func showActivityLog(for blog: Blog) {
        showBlogDetails(for: blog, then: .activity)
    }

    private static let statsPeriodTypeDefaultsKey = "LastSelectedStatsPeriodType"

    // MARK: - My Sites

    func showPages(for blog: Blog) {
        showBlogDetails(for: blog, then: .pages)
    }

    func showPosts(for blog: Blog) {
        showBlogDetails(for: blog, then: .posts)
    }

    func showMedia(for blog: Blog) {
        showBlogDetails(for: blog, then: .media)
    }

    func showComments(for blog: Blog) {
        showBlogDetails(for: blog, then: .comments)
    }

    func showSharing(for blog: Blog) {
        showBlogDetails(for: blog, then: .sharing)
    }

    func showPeople(for blog: Blog) {
        showBlogDetails(for: blog, then: .people)
    }

    func showPlugins(for blog: Blog) {
        showBlogDetails(for: blog, then: .plugins)
    }

    func showManagePlugins(for blog: Blog) {
        guard blog.supports(.pluginManagement) else {
            return
        }

        // PerformWithoutAnimation is required here, otherwise the view controllers
        // potentially get added to the navigation controller out of order
        // (ShowDetailViewController, used by MySiteViewController is animated)
        UIView.performWithoutAnimation {
            showBlogDetails(for: blog, then: .plugins)
        }

        guard let site = JetpackSiteRef(blog: blog),
            let navigationController = mySiteSplitViewController.topDetailViewController?.navigationController else {
            return
        }

        let query = PluginQuery.all(site: site)
        let listViewController = PluginListViewController(site: site, query: query)

        navigationController.pushViewController(listViewController, animated: false)
    }
}
