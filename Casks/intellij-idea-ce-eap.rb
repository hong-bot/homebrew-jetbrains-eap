cask "intellij-idea-ce-eap" do
  arch arm: "-aarch64"

  version "2023.3,233.10527.20"
  sha256 arm:   "c45c07efb7d6fc3faa0c8a03c70333fd77634981378e75ab7fc2604be001dc68",
         intel: "6f45a0c3eb71cd0948104aff9d0038028865efbcfa128fc7978c5f9670dc5242"

  url "https://download.jetbrains.com/idea/ideaIC-#{version.csv.second}#{arch}.dmg"
  name "IntelliJ IDEA Community Edition EAP"
  name "IntelliJ IDEA CE EAP"
  desc "IDE for Java development - community edition (EAP)"
  homepage "https://www.jetbrains.com/idea/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["IIC"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "IntelliJ IDEA #{version.major_minor} CE EAP.app"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "idea") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Caches/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Logs/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.intellij.ce-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.intellij.ce-EAP.savedState",
  ]
end
