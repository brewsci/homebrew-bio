class Gatk < Formula
  include Language::Python::Virtualenv

  # cite McKenna_2010: "https://doi.org/10.1101/gr.107524.110"
  desc "Genome Analysis Toolkit: Variant Discovery in High-Throughput Sequencing"
  homepage "https://github.com/broadinstitute/gatk"
  url "https://github.com/broadinstitute/gatk/releases/download/4.6.2.0/gatk-4.6.2.0.zip"
  sha256 "32d2f90bf13fcb3a8ac765bb2cb8ec1fc9a6cc447055d0156bd1db2092d4e3e8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # NOTE: torch 2.1.0 (pinned by GATK's conda env) only ships wheels through
  # cp311, so this formula is pinned to python@3.10 (GATK's exact pin). Bumping
  # Python requires bumping torch, which GATK ties to its gcnvkernel package.
  depends_on "libomp" # torch's OpenMP runtime, declared so `brew linkage` passes
  depends_on "openjdk@17"
  depends_on "python@3.10"
  depends_on "r"

  resource "homebrew-count_reads.bam" do
    url "https://github.com/broadinstitute/gatk/blob/626c88732c02b0fd5f395db20c91bf2784ec54b9/src/test/resources/org/broadinstitute/hellbender/tools/count_reads.bam?raw=true"
    sha256 "656e36331a39a3641565ef7810a529ac51270b4132007d7b94e6efff99133a2c"
  end

  def install
    # Use openjdk@17's java in the launcher.
    inreplace "gatk", "\"java\"", "\"#{formula_opt_bin("openjdk@17")}/java\""

    # Build the pinned Python environment GATK's Python tools (e.g. the gCNV
    # workflow) need. `venv.pip_install` forces --no-binary/--no-deps (can't
    # build torch), so drive pip directly against the venv to allow wheels.
    # The constraints file pins every transitive dependency for reproducible
    # builds (top-level versions mirror scripts/gatkcondaenv.yml.template).
    python = formula_opt_libexec("python@3.10")/"bin/python"
    venv = virtualenv_create(libexec/"venv", python)
    vpy = venv.root/"bin/python"

    constraints = buildpath/"constraints.txt"
    constraints.write <<~EOS
      Jinja2==3.1.6
      MarkupSafe==3.0.3
      PyVCF3==1.0.4
      PyYAML==6.0.3
      aiohappyeyeballs==2.6.2
      aiohttp==3.14.1
      aiosignal==1.4.0
      arviz==0.23.4
      async-timeout==5.0.1
      attrs==26.1.0
      biopython==1.84
      cachetools==7.1.4
      cloudpickle==3.1.2
      cons==0.4.7
      contourpy==1.3.2
      cycler==0.12.1
      dill==0.3.7
      etuples==0.3.10
      fastprogress==1.0.3
      filelock==3.29.4
      fonttools==4.63.0
      frozenlist==1.8.0
      fsspec==2026.6.0
      h5netcdf==1.8.1
      h5py==3.10.0
      idna==3.18
      joblib==1.5.3
      kiwisolver==1.5.0
      lightning-utilities==0.15.3
      logical-unification==0.4.7
      matplotlib==3.8.2
      miniKanren==1.0.5
      mpmath==1.3.0
      multidict==6.7.1
      multipledispatch==1.0.0
      networkx==3.4.2
      numpy==1.26.2
      packaging==26.2
      pandas==2.1.3
      pillow==12.2.0
      platformdirs==4.10.0
      propcache==0.5.2
      pymc==5.10.1
      pyparsing==3.3.2
      pysam==0.22.0
      pytensor==2.18.3
      python-dateutil==2.9.0.post0
      pytorch-lightning==2.4.0
      pytz==2026.2
      scikit-learn==1.3.2
      scipy==1.11.4
      six==1.17.0
      sympy==1.14.0
      threadpoolctl==3.6.0
      toolz==1.1.0
      torch==2.1.0
      torchmetrics==1.9.0
      tqdm==4.66.1
      typing_extensions==4.15.0
      tzdata==2026.2
      xarray-einstats==0.8.0
      xarray==2025.6.1
      yarl==1.24.2
    EOS
    pip = ["-m", "pip", "--python=#{vpy}", "install", "--constraint=#{constraints}"]

    if OS.linux?
      # PyPI's linux torch wheels are CUDA-only (multi-GB); use the CPU index.
      system python, *pip, "torch==2.1.0",
             "--index-url", "https://download.pytorch.org/whl/cpu",
             "--extra-index-url", "https://pypi.org/simple"
    else
      system python, *pip, "torch==2.1.0"
    end
    # `PyVCF3` (py3 fork of GATK's pyvcf 0.6.8) is imported by gcnvkernel;
    # `fastprogress` is held back from releases that pull in uvicorn[standard]
    # (a Rust watchfiles extension that breaks Homebrew's dylib relocation).
    system python, *pip,
           "numpy==1.26.2", "scipy==1.11.4", "pandas==2.1.3", "scikit-learn==1.3.2",
           "matplotlib==3.8.2", "h5py==3.10.0", "pymc==5.10.1", "pytensor==2.18.3",
           "pytorch-lightning==2.4.0", "biopython==1.84", "pysam==0.22.0",
           "tqdm==4.66.1", "dill==0.3.7", "fastprogress==1.0.3", "PyVCF3==1.0.4"
    # gcnvkernel ships inside the release archive.
    system python, *pip, buildpath/"gatkPythonPackageArchive.zip"

    # Install the R packages GATK's plotting/reporting scripts need. They build
    # from source against Homebrew's (rolling) R, so use the latest CRAN: a dated
    # snapshot would pin sources too old to compile against a newer R C API.
    # install.packages does not fail on error, so verify the set afterwards.
    r_lib = libexec/"lib/R"
    r_lib.mkpath
    ENV["R_LIBS_SITE"] = r_lib
    system formula_opt_bin("r")/"Rscript", "-e",
      "pkgs <- c('data.table','dplyr','getopt','ggplot2','gplots'," \
      "'gsalib','optparse','backports'); " \
      "install.packages(pkgs, repos='https://cloud.r-project.org'); " \
      "stopifnot(all(pkgs %in% rownames(installed.packages())))"

    # Install the Java toolkit.
    prefix.install "gatk", "scripts/dataproc-cluster-ui",
                   "gatk-package-#{version}-spark.jar",
                   "gatk-package-#{version}-local.jar"
    bash_completion.install "gatk-completion.sh"

    # GATK spawns `python`/`Rscript` from PATH, so front-load our venv and R libs.
    env = {
      PATH:        "#{libexec}/venv/bin:#{formula_opt_bin("r")}:$PATH",
      R_LIBS_SITE: r_lib,
    }
    (bin/"gatk").write_env_script prefix/"gatk", env
    (bin/"dataproc-cluster-ui").write_env_script prefix/"dataproc-cluster-ui", env
  end

  def caveats
    <<~EOS
      This formula bundles GATK's Python and R dependencies (Python tools such as
      the gCNV workflow, and R-based plotting) so they work out of the box.

      The gCNV tools are memory hungry; for very large cohorts the official Docker
      image may still be preferable:
        https://hub.docker.com/r/broadinstitute/gatk/tags/
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/gatk --help 2>&1")

    testpath.install resource("homebrew-count_reads.bam")
    assert_equal "Tool returned:\n8",
                 shell_output("#{bin}/gatk CountReads -I count_reads.bam --tmp-dir #{testpath}").strip

    # The bundled Python and R environments are complete.
    system libexec/"venv/bin/python", "-c", "import gcnvkernel, torch, pymc"
    ENV["R_LIBS_SITE"] = libexec/"lib/R"
    system formula_opt_bin("r")/"Rscript", "-e", "library(gsalib); library(ggplot2)"
  end
end
