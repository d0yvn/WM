//
//  Combine+UIControl.swift
//  
//
//  Created by USER on 2023/01/13.
//

import Combine
import Dispatch
import UIKit

extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
    }
    
    struct EventPublisher: Publisher {
        
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(control: control, subscrier: subscriber, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
    
    class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
        
        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscrier
            self.event = event
            
            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        @objc func eventDidOccur() {
            _ = subscriber?.receive(control)
        }
    }
}

// MARK: - UIButton
extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension UITextField {
    var shouldReturnPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .editingDidEndOnExit)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    var textPublisher: AnyPublisher<String, Never> {
        controlPublisher(for: .editingChanged)
            .compactMap { $0 as? UITextField }
            .compactMap { $0.text }
            .eraseToAnyPublisher()
    }
    
    var beginEditingPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .editingDidBegin)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }
}

// MARK: - WithLatestFrom
extension Publishers {
    struct WithLatestFrom<Upstream: Publisher, Side: Publisher, Output>: Publisher where Upstream.Failure == Side.Failure {
        typealias Failure = Side.Failure
        typealias ResultSelector = (Upstream.Output, Side.Output) -> Output
        
        let upstream: Upstream
        let side: Side
        let resultSelector: ResultSelector
        
        func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            let timestampedUpstream = upstream.map(TimestampedValue.init)
            let timestampedSide = side.map(TimestampedValue.init)
            let state = timestampedUpstream.combineLatest(timestampedSide, State.init)
            let mappedValues = state
                .filter { $0.upstream.time >= $0.side.time }
                .map { resultSelector($0.upstream.value, $0.side.value) }
            
            mappedValues.receive(subscriber: subscriber)
        }
        
        private struct TimestampedValue<T> {
            let value: T
            let time: DispatchTime
            
            init(value: T) {
                self.value = value
                self.time = DispatchTime.now()
            }
        }
        
        private struct State {
            let upstream: TimestampedValue<Upstream.Output>
            let side: TimestampedValue<Side.Output>
        }
    }
}

extension Publisher {
    func withLatestFrom<P: Publisher, R>(
        _ publisher: P,
        resultSelector: @escaping (Output, P.Output) -> R
    ) -> Publishers.WithLatestFrom<Self, P, R> {
        Publishers.WithLatestFrom(upstream: self, side: publisher, resultSelector: resultSelector)
    }
    
    func withLatestFrom<P: Publisher>(_ publisher: P) -> Publishers.WithLatestFrom<Self, P, P.Output> {
        withLatestFrom(publisher, resultSelector: { $1 })
    }
}
