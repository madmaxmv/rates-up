//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Combine

typealias RatesReducer = Reducer<
    RatesState,
    RatesEvent,
    RatesEnvironment
>

extension RatesState {
    static let reducer: RatesReducer = { state, event in
        switch event {
        case .initial:
            return [fetchRatesEffect]
        case .ratesResult(let result):
            state.ratesResult = result
        case .openRate(let id):
            guard
                case let .success(dailyRates) = state.ratesResult,
                let rate = dailyRates.rates.first(where: { $0.id == id })
            else {
                return []
            }
            return [open(currencyRate: rate)]
        default: break
        }

        return []
    }
}

private extension RatesState {
    static let fetchRatesEffect = Effect<RatesEvent, RatesEnvironment> { env in
        env.fetchRates(Date())
            .map { .ratesResult(.success($0)) }
    }

    static func open(currencyRate: CurrencyRate) -> Effect<RatesEvent, RatesEnvironment> {
        Effect<RatesEvent, RatesEnvironment> { env in
            env.navigateToRate(currencyRate)
            return Just(.nothing)
                .mapError { $0 as Error}
                .asPromise()
        }
    }
}