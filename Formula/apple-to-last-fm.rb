class AppleToLastFm < Formula
  desc "Scrobble Apple Music plays to Last.fm"
  homepage "https://github.com/jeremywrnr/apple-to-last-fm"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jeremywrnr/apple-to-last-fm/releases/download/v1.0.2/apple-to-last-fm-aarch64-apple-darwin.tar.xz"
      sha256 "e8cbdfe37fc13730b9114dfa40f164b95da6513df925038a02b80c7d3cfecddb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jeremywrnr/apple-to-last-fm/releases/download/v1.0.2/apple-to-last-fm-x86_64-apple-darwin.tar.xz"
      sha256 "e3d46058cbddd5d69f9be77a0f4174d2f561a360c5ea8c94b79fbecb1745a77d"
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
