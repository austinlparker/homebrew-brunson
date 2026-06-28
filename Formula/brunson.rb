class Brunson < Formula
  desc "Terminal PR manager with daemon/TUI split"
  homepage "https://github.com/austinlparker/brunson"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/austinlparker/brunson/releases/download/v0.1.0/brunson-aarch64-apple-darwin.tar.xz"
      sha256 "38508c86dfaa087e4d545568a38724504705b8efa3d98e84acb543b2931996bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/austinlparker/brunson/releases/download/v0.1.0/brunson-x86_64-apple-darwin.tar.xz"
      sha256 "dbc2e4238a2921410bddf479124802a03de110432c0349fd6e5dbb4f2bc7c9e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/austinlparker/brunson/releases/download/v0.1.0/brunson-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "85e40f318c25b07895ad8d283dd9dce9328d5a0e62eb36259c0c95a89058285b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/austinlparker/brunson/releases/download/v0.1.0/brunson-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7de7d7443d9e16748bb78eb15633c6f7a45d73c5969f185956c1ada2621f1882"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "brunson" if OS.mac? && Hardware::CPU.arm?
    bin.install "brunson" if OS.mac? && Hardware::CPU.intel?
    bin.install "brunson" if OS.linux? && Hardware::CPU.arm?
    bin.install "brunson" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
