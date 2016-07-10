//
//  ComplicationController.swift
//  iOSArduinoControl WatchKit Extension
//
//  Created by Philipp Gabriel on 20.05.16.
//  Copyright © 2016 Philipp Gabriel. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {

    // MARK: - Timeline Configuration

    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }

    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: (CLKComplicationTimelineEntry?) -> Void) {
        handler(nil)
    }


    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        handler(nil)
    }

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        handler(nil)
    }


    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }


}
