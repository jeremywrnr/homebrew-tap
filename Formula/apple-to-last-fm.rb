class AppleToLastFm < Formula
  desc "Scrobble Apple Music plays to Last.fm"
  homepage "https://github.com/jeremywrnr/apple-to-last-fm"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jeremywrnr/apple-to-last-fm/releases/download/1.0.0/apple-to-last-fm-aarch64-apple-darwin.tar.xz"
      sha256 "f4b9413e47af767dd32dbd2105d4a1ac5924e14909dfed1eb87310208cde5353"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jeremywrnr/apple-to-last-fm/releases/download/1.0.0/apple-to-last-fm-x86_64-apple-darwin.tar.xz"
      sha256 "ec0f13f3e5ac0bb016c3c35357ba09c00a7ec87ead88bcb35868ee1a7dda7ed1"
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
