class Bodr < Formula
  desc "Database of chemoinformatics"
  homepage "https://www.sourceforge.net/projects/bodr"
  url "https://downloads.sourceforge.net/project/bodr/bodr/10/bodr-10.tar.bz2"
  sha256 "738a0f0e263cdc088581d0a67a0ea16ec586ceb424704d0ff73bdb5da5d4ee81"

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
