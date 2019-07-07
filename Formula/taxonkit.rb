class Taxonkit < Formula
  desc "A cross-platform and efficient NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.5.0"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "52bc0f2bbd2286f5e4394e22c232851435f3b3b5d43834dd4f0bb5c362045569" => :sierra
    sha256 "57b2f2b8c6601ed954bbbfdba1c10fc54da88054bde8ff88a99b4f99e77d981b" => :x86_64_linux
  end

  if OS.mac?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.5.0/taxonkit_darwin_amd64.tar.gz"
    sha256 "0140f58e3bb4b9fef221a8ade2421d353148951e646e36ab2d04fe9247350b45"
  elsif OS.linux?
    url "https://github.com/shenwei356/taxonkit/releases/download/v0.5.0/taxonkit_linux_amd64.tar.gz"
    sha256 "ddd416bfacb80429d0853324d896fe2b50b7dbb57597408ad73dbb407c923c09"
  end

  def install
    bin.install "taxonkit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taxonkit --help 2>&1")
  end
end
