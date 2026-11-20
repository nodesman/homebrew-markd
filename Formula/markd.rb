class Markd < Formula
  desc "Native C++20 / Qt 6 Markdown instrument for the command line"
  homepage "https://markd.aramudan.dev"
  url "https://github.com/nodesman/markd-releases/releases/download/v0.1.2/Markd-0.1.2-darwin-arm64.tar.gz", using: :nounzip
  version "0.1.2"
  sha256 "4187b2779bf513a243f3ce111cf1c82b75318c79cc2459365e0b94917919bde2"
  license "GPL-3.0-only"

  def install
    # Keep the signed, self-contained Markd.app out of Homebrew Mach-O relocation, which
    # rewrites the bundled Qt linkage and breaks the app. Store the archive as a plain file
    # and unpack it in post_install, which runs after relocation.
    libexec.install Dir["*.tar.gz"].first => "Markd.tar.gz"
    bin.write_exec_script libexec/"Markd.app/Contents/MacOS/markd"
  end

  def post_install
    rm_r libexec/"Markd.app" if (libexec/"Markd.app").exist?
    system "tar", "-xzf", libexec/"Markd.tar.gz", "-C", libexec
    register_with_launch_services
  end

  def register_with_launch_services
    lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
    system lsregister, "-f", "#{opt_libexec}/Markd.app" if File.executable?(lsregister)
    system "#{bin}/markd", "--register-default"
  rescue StandardError
    nil
  end

  def caveats
    <<~EOS
      To ensure Finder opens .md files with Markd by default, run:
        markd --register-default
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/markd --version")
  end
end
