cask "intellij-idea-eap" do
  arch arm: "-aarch64"

  version "2025.1,251.20015.29"
  sha256 arm:   "1353ecf1ca96125d171d8d8df47c2a20b6e640c54bf67dd18ca41776f2e8e69f",
         intel: "0990386bbe2afe4a3d4634e85a40218a1bd8f6b8db25425bf844701bd85645f8"

  url "https://download.jetbrains.com/idea/ideaIU-#{version.csv.second}#{arch}.dmg"
  name "IntelliJ IDEA Ultimate"
  desc "Java IDE by JetBrains"
  homepage "https://www.jetbrains.com/idea/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["IIU"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "IntelliJ IDEA #{version.major_minor} EAP.app"
  binary "#{appdir}/IntelliJ IDEA #{version.major_minor} EAP.app/Contents/MacOS/idea", target: "idea-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "idea") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/IntelliJIdea#{version.major_minor}",
    "~/Library/Caches/JetBrains/IntelliJIdea#{version.major_minor}",
    "~/Library/Logs/JetBrains/IntelliJIdea#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.intellij-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.intellij-EAP.savedState",
  ]
end
