// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum App {
    /// On Air
    internal static let name = L10n.tr("Copy", "App.Name")
  }

  internal enum Network {
    internal enum Status {
      /// Waiting for nearby _On Air_ users…
      internal static let broadcastingNewSession = L10n.tr("Copy", "Network.Status.broadcastingNewSession")
      /// Connecting to an _On Air_ session…
      internal static let connectedToExistingSession = L10n.tr("Copy", "Network.Status.connectedToExistingSession")
      /// Hosting an _On Air_ session…
      internal static let hostingSession = L10n.tr("Copy", "Network.Status.hostingSession")
      /// Launching…
      internal static let idle = L10n.tr("Copy", "Network.Status.idle")
      /// Finding nearby _On Air_ users…
      internal static let searchingForActiveSessions = L10n.tr("Copy", "Network.Status.searchingForActiveSessions")
    }
  }

  internal enum Popover {
    internal enum ScreenRec {
      /// Find out why
      internal static let button = L10n.tr("Copy", "Popover.ScreenRec.Button")
      /// _On Air_ requires
      /// Screen Recording access.
      internal static let title = L10n.tr("Copy", "Popover.ScreenRec.Title")
      /// https://github.com/maxchuquimia/OnAir
      internal static let url = L10n.tr("Copy", "Popover.ScreenRec.Url")
    }
    internal enum Settings {
      /// Launch _On Air_ on login
      internal static let launchAtLogin = L10n.tr("Copy", "Popover.Settings.LaunchAtLogin")
      /// Quit
      internal static let quit = L10n.tr("Copy", "Popover.Settings.Quit")
    }
    internal enum Users {
      internal enum Me {
        /// This Computer
        internal static let title = L10n.tr("Copy", "Popover.Users.Me.Title")
      }
      internal enum Remote {
        /// Nearby People
        internal static let title = L10n.tr("Copy", "Popover.Users.Remote.Title")
      }
    }
    internal enum Version {
      /// On Air %s (%s)
      internal static func message(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
        return L10n.tr("Copy", "Popover.Version.Message", p1, p2)
      }
      internal enum Support {
        /// Support
        internal static let title = L10n.tr("Copy", "Popover.Version.Support.title")
        /// https://github.com/maxchuquimia/OnAir/issues
        internal static let url = L10n.tr("Copy", "Popover.Version.Support.url")
      }
      internal enum Updates {
        /// Check for updates
        internal static let title = L10n.tr("Copy", "Popover.Version.Updates.title")
        /// https://github.com/maxchuquimia/OnAir/releases
        internal static let url = L10n.tr("Copy", "Popover.Version.Updates.url")
      }
    }
  }

  internal enum UserStatus {
    ///  is _On Air_
    internal static let isOnAirSuffix = L10n.tr("Copy", "UserStatus.IsOnAirSuffix")
    internal enum Field {
      /// Enter Display Name
      internal static let placeholder = L10n.tr("Copy", "UserStatus.Field.Placeholder")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
