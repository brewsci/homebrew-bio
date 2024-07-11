class Mcl < Formula
  # cite Enright_2002: "https://doi.org/10.1093/nar/30.7.1575"
  desc "Clustering algorithm for graphs"
  homepage "https://micans.org/mcl"
  url "https://micans.org/mcl/src/mcl-22-282.tar.gz"
  sha256 "291f35837b6e852743bd87e499c5a46936125dcdf334f7747af92e88ac902183"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "5620623bbe8674f6c69ab21084b1dae29cfdf7cd07273efe1b9deba8ec6a4db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8535c8aec04127d0e51bf5c469c2127ec8143ce5afc37c9e038a853ab6fb2a20"
  end

  depends_on "pkg-config" => [:build, :test]

  uses_from_macos "perl"

  resource "cff" do
    url "https://micans.org/mcl/src/cimfomfa-22-273.tar.gz"
    sha256 "b0f0549fda1d288ddd22a2675581636a6f4bde0f01e956fcf452d0f815b4964f"
  end

  def install
    # Avoid `-flat_namespace` flag.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?
    # install cimfomfa.
    cff_dir = buildpath/"cff"
    resource("cff").stage do
      mkdir cff_dir
      cp_r ".", cff_dir
    end
    cd cff_dir do
      args = [
        "--prefix=#{prefix}",
        "--enable-shared",
        "--disable-static",
      ]
      # Hack for M1 Mac
      if Hardware::CPU.arm? && OS.mac?
        args << "--build=arm-apple-#{OS.kernel_name.downcase}#{OS.kernel_version.major}"
      end
      system "./configure", *args
      system "make", "install"
    end

    bin.mkpath
    ENV.append "LDFLAGS", "-L#{prefix}/lib"
    ENV.append "CPPFLAGS", "-I#{prefix}/include"
    # remove rcl-qm.R from the list of scripts to install
    inreplace "rcl/Makefile.in", "rcl-dot-resmap.pl rcl-qm.R rcl-relevel.pl", "rcl-dot-resmap.pl rcl-relevel.pl"
    system "./configure", "--prefix=#{prefix}", "--enable-rcl", "--disable-static", "--enable-shared"
    system "make", "install"
    # Install the R script in libexec
    libexec.install "rcl/rcl-qm.R"
    # Create a wrapper script to call the R script
    (bin/"rcl-qm.R").write <<~EOS
      #!/bin/bash
      Rscript "#{libexec}/rcl-qm.R" "$@"
    EOS
    chmod 0755, bin/"rcl-qm.R"

    inreplace bin/"rcl-relevel.pl", "#!/usr/bin/perl", "#!/usr/bin/env perl"
    inreplace bin/"rcl-dot-resmap.pl", "#!/usr/bin/perl", "#!/usr/bin/env perl"
    inreplace bin/"rcl-select.pl", "#!/usr/bin/perl", "#!/usr/bin/env perl"
    inreplace bin/"rcldo.pl", "#!/usr/bin/perl", "#!/usr/bin/env perl"
  end

  test do
    assert_match "iterands", shell_output("#{bin}/mcl -h 2>&1")
  end
end
