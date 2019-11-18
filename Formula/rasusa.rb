class Rasusa < Formula
  # cite Hall_2019: "https://doi.org/10.5281/zenodo.3546168"
  desc "Randomly subsample sequencing reads to a specified coverage"
  homepage "https://github.com/mbhall88/rasusa"
  version "0.1.0"

  if OS.mac?
    url "https://github.com/mbhall88/rasusa/releases/download/#{version}/rasusa-#{version}-x86_64-apple-darwin.tar.gz"
    sha256 "f485fe769c6170020bd7dc65205a7139dcecff03f4808a9241bd2843a36b6e83"
  elsif OS.linux?
    url "https://github.com/mbhall88/rasusa/releases/download/#{version}/rasusa-#{version}-x86_64-unknown-linux-musl.tar.gz"
    sha256 "eb6d1c1ab48bd3fd568fd7dad338352c54a514762502fc2ec4172ae792a77832"
  end

  def install
    bin.install "rasusa"
  end

  test do
    system "#{bin}/rasusa", "--help"
  end
end
