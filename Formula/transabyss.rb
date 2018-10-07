class Transabyss < Formula
  # cite Robertson_2010: "https://doi.org/10.1038/nmeth.1517"
  desc "De novo assembly of RNA-seq data using ABySS"
  homepage "https://github.com/bcgsc/transabyss"
  url "https://github.com/bcgsc/transabyss/archive/2.0.1.tar.gz"
  sha256 "9101107d1df5ae86dd6a87d26181bb4c1967724e2560bc3b8ca44c30ce85ce12"
  head "https://github.com/bcgsc/transabyss.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "c3adcd840c6bdebae3a6a0018138ee47d8ca0da01713ba35973bf89b3e2a39a8" => :x86_64_linux
  end

  depends_on "abyss"
  depends_on "blat"
  depends_on "igraph"

  # pip3 install python-igraph fails on macOS with the error
  # ld: file not found: /usr/lib/system/libsystem_darwin.dylib for architecture x86_64
  depends_on :linux

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "pip3", "install", "--prefix=#{libexec}", "python-igraph"

    inreplace Dir["transabyss", "transabyss-merge"], "#!/usr/bin/env python", "#!#{Formula["python3"].bin}/python3"
    prefix.install Dir["*"]
    (bin/"transabyss").write_env_script prefix/"transabyss", :PYTHONPATH => ENV["PYTHONPATH"]
    (bin/"transabyss-merge").write_env_script prefix/"transabyss-merge", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    assert_match "usage", shell_output("#{bin}/transabyss --help")
    assert_match "usage", shell_output("#{bin}/transabyss-merge --help")
  end
end
