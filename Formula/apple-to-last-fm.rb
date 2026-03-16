class AppleToLastFm < Formula
  desc "Scrobble Apple Music plays to Last.fm"
  homepage "https://github.com/jeremywrnr/apple-to-last-fm"
  version "1.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jeremywrnr/apple-to-last-fm/releases/download/v1.1.2/apple-to-last-fm-aarch64-apple-darwin.tar.xz"
      sha256 "2203e4ddb656e0e399bacceedd098a1aeb2c5cd9206460093a0a0404a1ed8400"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jeremywrnr/apple-to-last-fm/releases/download/v1.1.2/apple-to-last-fm-x86_64-apple-darwin.tar.xz"
      sha256 "0a30c495aaf5b34ff8817fbd0ff0f10096d36133c9b5d0c98fef33692cfc2fa7"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "apple-to-last-fm" if OS.mac? && Hardware::CPU.arm?
    bin.install "apple-to-last-fm" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
