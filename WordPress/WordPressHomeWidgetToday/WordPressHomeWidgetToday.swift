import WidgetKit
import SwiftUI

// TODO - TODAYWIDGET: remove this static model when real data come in.
let staticModel = TodayWidgetContent(siteTitle: "Around the world with Pam",
                                   views: 1752,
                                   visitors: 5000,
                                   likes: 5000,
                                   comments: 250)

struct Provider: TimelineProvider {


    func placeholder(in context: Context) -> TodayWidgetContent {
        staticModel
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayWidgetContent) -> ()) {
        let entry = staticModel
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let entries = [staticModel]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


@main
struct WordPressHomeWidgetToday: Widget {
    private let kind: String = "WordPressHomeWidgetToday"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodayWidgetView(content: staticModel)
        }
        .configurationDisplayName("WordPress Today Widget.")
    }
}

struct WordPressHomeWidgetToday_Previews: PreviewProvider {
    static var previews: some View {
        TodayWidgetView(content: staticModel)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
