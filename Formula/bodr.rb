class Bodr < Formula
  desc "Database of chemoinformatics"
  homepage "https://www.sourceforge.net/projects/bodr"
  url "https://downloads.sourceforge.net/project/bodr/bodr/10/bodr-10.tar.bz2"
  sha256 "738a0f0e263cdc088581d0a67a0ea16ec586ceb424704d0ff73bdb5da5d4ee81"
  license "CC0-1.0"

  livecheck do
    url "https://sourceforge.net/projects/bodr/files/bodr/"
    strategy :page_match
    regex(%r{href=.*?bodr/v?(\d+)/?["' >]}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "87f1a1334eeccaba523dd941872090b5d2ed138f2f3759d7c27d1e39a2195abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "902e4559129e1c0bc5e72e172b263ce6686423c82cb6dfdc15d1ed25c6eef01c"
  end

  on_linux do
    depends_on "libxml2" => [:build, :test]
    depends_on "libxslt" => :build
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Install CML schema for testing purposes
    (pkgshare/"schema").install "schemas/cml25.xsd"
  end

  test do
    system "xmllint", pkgshare/"isotopes.xml", "--schema", pkgshare/"schema/cml25.xsd", "--noout"
  end
end
