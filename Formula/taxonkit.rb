class Taxonkit < Formula
  desc "A cross-platform and efficient NCBI taxonomy toolkit"
  homepage "https://github.com/shenwei356/taxonkit"
  version "0.5.0"
  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0afc6abccfda04fc09e9672a9952a73069a9d8831bd77e40b084657487b5ab83" => :sierra
    sha256 "79f1c7f5af26435d0d09a69ce52236cd9b16a30e37ba3063a78cd8117a54a9e5" => :x86_64_linux
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
