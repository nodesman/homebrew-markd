class Markd < Formula
  desc "Native C++20 / Qt 6 Markdown instrument for the command line"
  homepage "https://markd.aramudan.dev"
  url "https://github.com/nodesman/markd-releases/releases/download/v0.1.0/Markd-0.1.0-darwin-arm64.tar.gz"
  version "0.1.0"
  sha256 "b5f914dfa2f372233b43f0254b7840d4e3f47cd249f61876313ae04ee424bbce"
  license "MIT"

  def install
    libexec.install "Markd.app"
    bin.write_exec_script libexec/"Markd.app/Contents/MacOS/markd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/markd --version")
  end
end
