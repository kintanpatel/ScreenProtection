//
//  ContentView.swift
//  ScreenProtection
//
//  Created by AK on 02/02/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var protectionEnabled = true

    private var accentGradient: LinearGradient {
        LinearGradient(
            colors: [Color(red: 0.2, green: 0.6, blue: 0.55), Color(red: 0.15, green: 0.45, blue: 0.5)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var accentTeal: Color { Color(red: 0.2, green: 0.55, blue: 0.5) }
    private var accentTealDark: Color { Color(red: 0.4, green: 0.75, blue: 0.7) }

    private var cardBackground: Color { Color(.secondarySystemGroupedBackground) }
    private var tertiaryBackground: Color { Color(.tertiarySystemGroupedBackground) }
    private var shadowOpacity: Double { colorScheme == .dark ? 0.08 : 0.06 }
    private var shadowRadius: CGFloat { colorScheme == .dark ? 8 : 16 }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    heroSection
                    protectionToggleSection
                    protectedContentSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .background(backgroundGradient)
            .navigationTitle("Screen Protection")
            .navigationBarTitleDisplayMode(.inline)
            .screenProtection(enabled: protectionEnabled)
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemGroupedBackground),
                Color(.secondarySystemGroupedBackground)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(protectionEnabled ? accentGradient : LinearGradient(colors: [.gray.opacity(0.4), .gray.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 88, height: 88)
                    .shadow(color: (protectionEnabled ? accentTeal : .gray).opacity(colorScheme == .dark ? 0.4 : 0.35), radius: 12, x: 0, y: 6)

                Image(systemName: protectionEnabled ? "shield.fill" : "shield.slash.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(.white)
            }

            Text(protectionEnabled ? "You're protected" : "Protection off")
                .font(.title2.weight(.bold))
                .foregroundStyle(protectionEnabled ? (colorScheme == .dark ? accentTealDark : Color(red: 0.15, green: 0.45, blue: 0.42)) : .secondary)

            Text(protectionEnabled ? "Recording and screenshots are blocked" : "Turn on to hide content from recording & screenshots")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(cardBackground)
                .shadow(color: .primary.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 8)
        )
    }

    private var protectionToggleSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "togglepower")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(accentGradient)
                Text("Protection")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
            }

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Screen recording & screenshot")
                        .font(.subheadline.weight(.medium))
                    Text(protectionEnabled ? "Blocked · Content is hidden" : "Allowed · Content visible")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Toggle("", isOn: $protectionEnabled)
                    .labelsHidden()
                    .tint(colorScheme == .dark ? accentTealDark : accentTeal)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardBackground)
                    .shadow(color: .primary.opacity(shadowOpacity), radius: colorScheme == .dark ? 6 : 10, x: 0, y: 4)
            )
        }
    }

    private var protectedContentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(accentGradient)
                Text("What's protected")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
            }

            VStack(spacing: 12) {
                protectionItem(
                    icon: "video.slash",
                    title: "Screen recording",
                    detail: "When recording is on, this screen shows \"Not Allowed\" instead of content."
                )
                protectionItem(
                    icon: "camera.fill",
                    title: "Screenshots",
                    detail: "Screenshots show a blank mask over this content so nothing is captured."
                )
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardBackground)
                    .shadow(color: .primary.opacity(shadowOpacity), radius: colorScheme == .dark ? 6 : 10, x: 0, y: 4)
            )
        }
    }

    private func protectionItem(icon: String, title: String, detail: String) -> some View {
        let (iconColor, iconBg): (Color, Color) = {
            if icon == "video.slash" {
                return colorScheme == .dark
                    ? (Color(red: 1, green: 0.45, blue: 0.45), Color(red: 0.4, green: 0.2, blue: 0.2))
                    : (Color(red: 0.85, green: 0.35, blue: 0.35), Color(red: 0.95, green: 0.9, blue: 0.9))
            } else {
                return colorScheme == .dark
                    ? (Color(red: 0.5, green: 0.75, blue: 1), Color(red: 0.2, green: 0.3, blue: 0.45))
                    : (Color(red: 0.25, green: 0.5, blue: 0.7), Color(red: 0.9, green: 0.94, blue: 0.98))
            }
        }()
        return HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconBg)
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(iconColor)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 14).fill(tertiaryBackground))
    }
}

#Preview {
    ContentView()
}
