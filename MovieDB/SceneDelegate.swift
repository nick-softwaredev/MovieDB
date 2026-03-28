//
//  SceneDelegate.swift
//  MovieDB
//
//  Created by N on 2026-03-27.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  private var appCoordinator: AppCoordinator?
  private var dependencies: AppDependencies?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScene)
    let dependencies = AppDependencies.live()
    let coordinator = dependencies.makeAppCoordinator(window: window)

    self.window = window
    self.dependencies = dependencies
    appCoordinator = coordinator

    coordinator.start()
    handleDeepLink(in: connectionOptions)
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    appCoordinator?.handle(url: url)
  }

  private func handleDeepLink(in connectionOptions: UIScene.ConnectionOptions) {
    guard let url = connectionOptions.urlContexts.first?.url else { return }
    appCoordinator?.handle(url: url)
  }
}
