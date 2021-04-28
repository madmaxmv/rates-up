//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Combine

typealias CurrencyRateStore = Store<
    CurrencyRateState,
    CurrencyRateEvent,
    CurrencyRateEnvironment
>

struct CurrencyRateState {

    let currencyRate: CurrencyRate
    var dynamics: RateDynamicsResult? = nil
}

enum CurrencyRateEvent {
    case loadDynamics
    case dynamicsResult(RateDynamicsResult)
    case close, nothing
}

typealias CurrencyRateReducer = Reducer<
    CurrencyRateState,
    CurrencyRateEvent,
    CurrencyRateEnvironment
>

extension CurrencyRateState {
    static let reducer: CurrencyRateReducer = { state, event in
        switch event {
        case .loadDynamics:
            return [
                fetchDynamics(id: state.currencyRate.id)
            ]
        case .dynamicsResult(let result):
            state.dynamics = result
        case .close:
            return [closeEffect]
        case .nothing:
            return []
        }
        return []
    }
}

extension CurrencyRateState {
    static func fetchDynamics(id: String) -> Effect<CurrencyRateEvent, CurrencyRateEnvironment> {
        return Effect { env in
            env.fetchDynamics(id)
                .map { .dynamicsResult(.success($0)) }
        }
    }

    static let closeEffect = Effect<CurrencyRateEvent, CurrencyRateEnvironment> { env in
        env.closeScreen()
        return Just(.nothing)
            .mapError { $0 as Error }
            .asPromise()
    }
}

struct CurrencyRateEnvironment {

    let fetchDynamics: (String) -> Promise<RateDynamics, Error>
    let closeScreen: () -> Void

    init(services: AppServices) {
        fetchDynamics = { currencyID in
            services.dynamicsProvider
                .dynamicsForCurrency(
                    with: currencyID,
                    dateRange: (
                        from: Date().addingTimeInterval(-60.0*60*24*30),
                        to: Date()
                    )
                ).asPromise()
        }

        closeScreen = {
            services.screenNavigator
                .navigate(fromTop: .modalContainer) { route in
                    route.dismiss(animated: true)
            }
        }
    }
}
