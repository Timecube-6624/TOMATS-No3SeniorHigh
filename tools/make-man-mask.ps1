# 生成 assets/man-mask.png
# ---------------------------------------------------------------------------
# 用途：让海面动画「停在老人轮廓之外」，也就是水在人的后面。
#   白色不透明 = 可以出水   透明 = 老人所在处（禁止位移/高光/浪花覆盖）
# 做法：OldMan-Body.png 是 Background.png 的 1:1 逐像素抠图，
#       实测对齐在整幅画 (2304x1728) 的 (220, 199)，缩放 1.0000。
#       取其 alpha，反转（255-a），半分辨率下采样到 1152x864，
#       再把轮廓向外胀 1 格（半分辨率 = 原画 2px），确保轮廓边缘不渗水。
# 同时输出 _check.png：把受保护区域染绿叠在原画上，用于肉眼核对位置。
param(
    [string]$ArtPath  = (Join-Path $PSScriptRoot '..\assets\Background.png'),
    [string]$BodyPath = (Join-Path $PSScriptRoot '..\assets\OldMan-Body.png'),
    [string]$OutPath  = (Join-Path $PSScriptRoot '..\assets\man-mask.png'),
    [string]$CheckPath = (Join-Path $env:TEMP 'man-mask-check.png')
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$DX = 220; $DY = 199; $SCALE_HALF = 2   # 半分辨率下每个 mask 像素 = 2x2 原画像素

$src = @'
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class ManMask {
    static byte[] Bytes(Bitmap b) {
        Rectangle r = new Rectangle(0, 0, b.Width, b.Height);
        BitmapData bd = b.LockBits(r, ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
        byte[] buf = new byte[bd.Stride * b.Height];
        System.Runtime.InteropServices.Marshal.Copy(bd.Scan0, buf, 0, buf.Length);
        b.UnlockBits(bd);
        return buf;
    }
    static Bitmap ToArgb(Bitmap s) {
        Bitmap d = new Bitmap(s.Width, s.Height, PixelFormat.Format32bppArgb);
        using (Graphics g = Graphics.FromImage(d)) {
            g.CompositingMode = System.Drawing.Drawing2D.CompositingMode.SourceCopy;
            g.DrawImage(s, 0, 0, s.Width, s.Height);
        }
        return d;
    }

    // 返回 manA[]（0..1，1=老人）在 outW x outH 的半分辨率网格上
    static float[] ManAlpha(string bodyPath, int outW, int outH, int dx, int dy, int step) {
        Bitmap body = ToArgb((Bitmap)Image.FromFile(bodyPath));
        int bw = body.Width, bh = body.Height;
        byte[] B = Bytes(body);
        float[] m = new float[outW * outH];
        for (int py = 0; py < outH; py++) {
            for (int px = 0; px < outW; px++) {
                int acc = 0, n = 0;
                for (int v = 0; v < step; v++) {
                    for (int u = 0; u < step; u++) {
                        int bx = (px * step + u) - dx;
                        int by = (py * step + v) - dy;
                        if (bx >= 0 && by >= 0 && bx < bw && by < bh) {
                            acc += B[(by * bw + bx) * 4 + 3];
                            n++;
                        }
                    }
                }
                m[py * outW + px] = n == 0 ? 0f : (acc / (float)n) / 255f;
            }
        }
        body.Dispose();
        return m;
    }

    static float[] Dilate(float[] m, int w, int h) {
        float[] o = new float[m.Length];
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                float best = 0f;
                for (int j = -1; j <= 1; j++) {
                    int yy = y + j; if (yy < 0 || yy >= h) continue;
                    for (int i = -1; i <= 1; i++) {
                        int xx = x + i; if (xx < 0 || xx >= w) continue;
                        float v = m[yy * w + xx];
                        if (v > best) best = v;
                    }
                }
                o[y * w + x] = best;
            }
        }
        return o;
    }

    public static string Run(string artPath, string bodyPath, string outPath, string checkPath, int dx, int dy, int step) {
        Bitmap art = ToArgb((Bitmap)Image.FromFile(artPath));
        int aw = art.Width, ah = art.Height;
        int ow = aw / step, oh = ah / step;

        float[] man = ManAlpha(bodyPath, ow, oh, dx, dy, step);
        man = Dilate(man, ow, oh);

        // ---- 蒙版：alpha = 255 表示可以出水，0 表示老人 ----
        Bitmap mask = new Bitmap(ow, oh, PixelFormat.Format32bppArgb);
        Rectangle rect = new Rectangle(0, 0, ow, oh);
        BitmapData md = mask.LockBits(rect, ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);
        byte[] mb = new byte[md.Stride * oh];
        int covered = 0;
        for (int y = 0; y < oh; y++) {
            for (int x = 0; x < ow; x++) {
                int a = (int)Math.Round(255.0 * (1.0 - man[y * ow + x]));
                if (a < 255) covered++;
                int o = y * md.Stride + x * 4;
                mb[o] = 255; mb[o + 1] = 255; mb[o + 2] = 255; mb[o + 3] = (byte)a;
            }
        }
        System.Runtime.InteropServices.Marshal.Copy(mb, 0, md.Scan0, mb.Length);
        mask.UnlockBits(md);
        mask.Save(outPath, ImageFormat.Png);

        // ---- 核对图：受保护区域染绿 ----
        Bitmap check = new Bitmap(aw, ah, PixelFormat.Format32bppArgb);
        using (Graphics g = Graphics.FromImage(check)) {
            g.DrawImage(art, 0, 0, aw, ah);
        }
        BitmapData cd = check.LockBits(new Rectangle(0, 0, aw, ah), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
        byte[] cb = new byte[cd.Stride * ah];
        System.Runtime.InteropServices.Marshal.Copy(cd.Scan0, cb, 0, cb.Length);
        for (int y = 0; y < ah; y++) {
            for (int x = 0; x < aw; x++) {
                float mA = man[(y / step) * ow + (x / step)];
                if (mA <= 0.002f) continue;
                int o = y * cd.Stride + x * 4;
                cb[o]     = (byte)Math.Min(255, cb[o]     * (1 - mA) + 0   * mA);   // B
                cb[o + 1] = (byte)Math.Min(255, cb[o + 1] * (1 - mA) + 255 * mA);   // G
                cb[o + 2] = (byte)Math.Min(255, cb[o + 2] * (1 - mA) + 0   * mA);   // R
            }
        }
        System.Runtime.InteropServices.Marshal.Copy(cb, 0, cd.Scan0, cb.Length);
        check.UnlockBits(cd);
        string checkPathOut = checkPath;
        Bitmap checkSmall = new Bitmap(check, 1152, 864);
        checkSmall.Save(checkPathOut, ImageFormat.Png);
        checkSmall.Dispose(); check.Dispose(); art.Dispose(); mask.Dispose();

        return "size=" + ow + "x" + oh + " protectedPx=" + covered + " (" + (100.0 * covered / (ow * oh)).ToString("0.00") + "%)";
    }
}
'@
Add-Type -TypeDefinition $src -ReferencedAssemblies System.Drawing, System.Drawing.Primitives

$info = [ManMask]::Run($ArtPath, $BodyPath, $OutPath, $CheckPath, $DX, $DY, $SCALE_HALF)
$kb = [math]::Round((Get-Item $OutPath).Length / 1KB, 1)
$info + "  ->  " + (Split-Path $OutPath -Leaf) + " " + $kb + "KB"
"核对图（受保护区域染绿）: " + $CheckPath
