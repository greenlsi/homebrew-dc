class Rxnet < Formula
  desc "Reactive synchronous runtime library — C implementation"
  homepage "https://github.com/greenlsi/rxnet"
  url "https://github.com/greenlsi/rxnet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3ae431d4d6076c041a845fad11ae2939bbcb21a8b998dc6bf4141f73ca55a21c"
  version "1.0.0"
  license "GPL-3.0-or-later"

  def install
    system "make", "-C", "c", "lib"
    lib.install Dir["c/build/librxnet*.a"]
    (include/"rxnet").install Dir["c/include/rxnet/*.h"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rxnet/runtime.h>
      int main(void) { (void)sizeof(rx_runtime); return 0; }
    C
    system ENV.cc, "-std=c99", "-I#{include}", "test.c", "-L#{lib}", "-lrxnet", "-o", "test"
    system "./test"
  end
end
