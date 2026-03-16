class AppleToLastFm < Formula
  desc "Scrobble Apple Music plays to Last.fm"
  homepage "https://github.com/jeremywrnr/apple-to-last-fm"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jeremywrnr/apple-to-last-fm/releases/download/v0.1.2/apple-to-last-fm-aarch64-apple-darwin.tar.xz"
      sha256 "cd3e8f8c4815ad270317225b3ea3fe4e22591f6e08ae9aa02702a50beb4283f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jeremywrnr/apple-to-last-fm/releases/download/v0.1.2/apple-to-last-fm-x86_64-apple-darwin.tar.xz"
      sha256 "bb8fc9ef0514c26d57c1a39bd5eb15c63eecff3a6304da35f6525b6a2cdc59c0"
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
