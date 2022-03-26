use strict;
use warnings;
use Test::More tests => 5;
use XML::Enc;
use MIME::Base64 qw/decode_base64/;

my $base64 = <<'BASE64';
PD94bWwgdmVyc2lvbj0iMS4wIj8+CjxFbmNyeXB0ZWREYXRhIHhtbG5zPSJodHRwOi8vd3d3Lncz
Lm9yZy8yMDAxLzA0L3htbGVuYyMiIFR5cGU9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1s
ZW5jI0VsZW1lbnQiPgogPEVuY3J5cHRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3Lncz
Lm9yZy8yMDAxLzA0L3htbGVuYyN0cmlwbGVkZXMtY2JjIi8+CiA8S2V5SW5mbyB4bWxucz0iaHR0
cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+CiAgPEVuY3J5cHRlZEtleSB4bWxucz0i
aHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjIj4KICAgPEVuY3J5cHRpb25NZXRob2Qg
QWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNyc2EtMV81Ii8+CiAg
IDxLZXlJbmZvIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj4KICAg
IDxLZXlOYW1lLz4KICAgPC9LZXlJbmZvPgogICA8Q2lwaGVyRGF0YT4KICAgIDxDaXBoZXJWYWx1
ZT5sRDBpOFlwc2xNMDN2S1MwODNpMWRtc1BWZGlUeWJuVzRzR21GU2tXc1pvMS9xZmI4M2JpT05w
SU9LV2lheXZ2CjBobCt0QU5GZjU5NkRHV3B2ek96UGFCaVViWFh5MXRRWEJmem1ycTJBREkvaHUy
MWhuajl6eTJDSjREaTdhMlAKclNOazZZUEtKOUxHakQ5SU9mSk5lNHdsWFhldUh0VjU1Tk1CcGs0
Ui9iaWtWZnlNWkxVTm5lODJjN3lQeFgrawplcmJnTXZ5YnphR20zSWRVbXhlUmVJcm9wVVd4anhH
L2NEcU5LbmVodi9sZTRGb0plbjNlakR5QkNHVDRlc1JBClJvRExPbTVHSE5YVGRySlRnLzdzbVI1
b2QrNEQ2Z3BwN2FqN1phTy91SS84ZGcxSE1kbUprSUtrQU1aNmNwNlUKRHBPd1JBNGtRTUt1a3py
RVlnSVBuRlZxeHVLdC9kMFdCSkFabmFGSHNkMXZPN0tqTGxhUjd6aGhBT0xEeVFJVwpGZmJDRE0v
SHg0SmY5YmczbzhQcjdWQ25aMmhRdy9qaWxPTzZhT3p4aVBDYTJhVjVjenNKNTIzQW1iV2M0eDJo
Cml1VmUxMzJnMGVUdWdjM2Q3WmRYRTVmYmgzZWVVcVl6QmhWdUtqRVA1UkRrdExYbGJHN1Fhc05z
SmkyMEdFbDAKazlHR2RZUXpQUHVSc2lDVFVTUEV1UzkzRXVCVGVmNU44aWpZbzdMaHFwOUxiTXBs
M01NQVVTdW5zR3J4NEsrRgo3TFpLbFpiRlpQSG9hRW5zS2s1TFg5eXZWdldzR2hHb21VT05iQmcw
ZU43djBIVytUSXdvN2tEc0dJVkhXUDFoClRDWHphNVNTSDM3WnBtTFprWEp2ODlqSlA1TDVYWi83
N2svU0txbkE0ZFE9PC9DaXBoZXJWYWx1ZT4KICAgPC9DaXBoZXJEYXRhPgogIDwvRW5jcnlwdGVk
S2V5PgogPC9LZXlJbmZvPgogPENpcGhlckRhdGE+CiAgPENpcGhlclZhbHVlPkIrUzZJRzFtMUJw
d3pLRC9icE1qdDRJa203cDlBTUpLNWhUbUxwYXMyeDIxVG90RDUwb0hvcVg3UTBSd25wS0sKSHVy
bm9reGlacSsxZmx2K21OS2xpR0tKczZZZ3c4aXpLYUUrSW42NjJZRT08L0NpcGhlclZhbHVlPgog
PC9DaXBoZXJEYXRhPgo8L0VuY3J5cHRlZERhdGE+Cg==
BASE64

my $xml = decode_base64($base64);

ok($xml, "Got encrypted XML");

my $decrypter = XML::Enc->new(
    {
        key                 => 't/sign-private.pem',
        no_xml_declaration  => 1
    }
);

ok($decrypter->decrypt($xml) =~ /foo/, "Successfully Decrypted");

$base64 = <<'SAMLRESP';
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c2FtbDJwOlJlc3BvbnNlIERlc3RpbmF0aW9uPSJodHRwczovL25ldHNhbWwyLXRlc3RhcHAubG9jYWwvY29uc3VtZXItcG9zdCIgSUQ9ImlkMzE1NTg3NjM4ODI2NDg4ODc2Njg3NzA5MSIgSW5SZXNwb25zZVRvPSJORVRTQU1MMl83ZTE5NTIwMTc2YzJlZDc4NWFkZWQ3NmFlODc5NjM5NCIgSXNzdWVJbnN0YW50PSIyMDIyLTAzLTIzVDIwOjA1OjE5LjIzN1oiIFZlcnNpb249IjIuMCIgeG1sbnM6c2FtbDJwPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6cHJvdG9jb2wiPjxzYW1sMjpJc3N1ZXIgRm9ybWF0PSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6bmFtZWlkLWZvcm1hdDplbnRpdHkiIHhtbG5zOnNhbWwyPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YXNzZXJ0aW9uIj5odHRwOi8vd3d3Lm9rdGEuY29tL2V4azI4d3RiN3R1T2VmNUY5NWQ3PC9zYW1sMjpJc3N1ZXI+PGRzOlNpZ25hdHVyZSB4bWxuczpkcz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PGRzOlNpZ25lZEluZm8+PGRzOkNhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiLz48ZHM6U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxkc2lnLW1vcmUjcnNhLXNoYTI1NiIvPjxkczpSZWZlcmVuY2UgVVJJPSIjaWQzMTU1ODc2Mzg4MjY0ODg4NzY2ODc3MDkxIj48ZHM6VHJhbnNmb3Jtcz48ZHM6VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48ZHM6VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+PC9kczpUcmFuc2Zvcm1zPjxkczpEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNzaGEyNTYiLz48ZHM6RGlnZXN0VmFsdWU+VytQcjhhbjhtL0RwTFN3cURRTU82S1B6K3Jmemt6VjgxN3M4UUFBd2lJdz08L2RzOkRpZ2VzdFZhbHVlPjwvZHM6UmVmZXJlbmNlPjwvZHM6U2lnbmVkSW5mbz48ZHM6U2lnbmF0dXJlVmFsdWU+ZFN5WDdXYktHdGtlSDFDU0hrUWZLUmZiMElUR29kTGM3S2JidmMvbVRUMjFxeG9WdTJoK2FUOENRYUNSOXdFaDBTQ21PalAzZHFVemlhNjBVMHlrTUdadGVqc3cyVFVvZ1pLQkRDd29pZ2NkK1hjR0l3b0lZZktOWWw2WWlDRUhVdVZxejcxNG5FeG9YUXhvVEJqR0R3S2lEWmJyc1Y5Q1NBQnJvRVZSY2s0cGhHbmRwYlNmRDd2cXFSdURVdjVGZ2VJbVdqRW9QS2pPV1hXeEFCS2dMemNQRUxIUUdnem9FdHdMa0g5aG5lQ0Z2NnZidlhBcWJxK0t1Tk4yNjcwd1NIQ0JJU016NHBHL0N2Tml0bmpYK1VMOW4wS0Z4Nk8wR2gwemplZUZqWW55WWhYN2ZldGpta2R5TzNtRy9MZXZwV2x2cmRGaVRBTUgvRmZlOE5pbEpBPT08L2RzOlNpZ25hdHVyZVZhbHVlPjxkczpLZXlJbmZvPjxkczpYNTA5RGF0YT48ZHM6WDUwOUNlcnRpZmljYXRlPk1JSURxRENDQXBDZ0F3SUJBZ0lHQVh5QWVuZERNQTBHQ1NxR1NJYjNEUUVCQ3dVQU1JR1VNUXN3Q1FZRFZRUUdFd0pWVXpFVE1CRUcKQTFVRUNBd0tRMkZzYVdadmNtNXBZVEVXTUJRR0ExVUVCd3dOVTJGdUlFWnlZVzVqYVhOamJ6RU5NQXNHQTFVRUNnd0VUMnQwWVRFVQpNQklHQTFVRUN3d0xVMU5QVUhKdmRtbGtaWEl4RlRBVEJnTlZCQU1NREdSbGRpMHpNemc0T1RjMk16RWNNQm9HQ1NxR1NJYjNEUUVKCkFSWU5hVzVtYjBCdmEzUmhMbU52YlRBZUZ3MHlNVEV3TVRReU1ESXpOREphRncwek1URXdNVFF5TURJME5ESmFNSUdVTVFzd0NRWUQKVlFRR0V3SlZVekVUTUJFR0ExVUVDQXdLUTJGc2FXWnZjbTVwWVRFV01CUUdBMVVFQnd3TlUyRnVJRVp5WVc1amFYTmpiekVOTUFzRwpBMVVFQ2d3RVQydDBZVEVVTUJJR0ExVUVDd3dMVTFOUFVISnZkbWxrWlhJeEZUQVRCZ05WQkFNTURHUmxkaTB6TXpnNE9UYzJNekVjCk1Cb0dDU3FHU0liM0RRRUpBUllOYVc1bWIwQnZhM1JoTG1OdmJUQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0MKZ2dFQkFMUXF4NHE2WVI3cDF2SkQ1UWF2WEltK3VaVjA1bWRaUVd1UDhkdUllbkhoQ3JUZEEwZnB1M1VhZ05zb1NQZ1NlTnU4R1o4QgoyYmNmTVdINnRWUVMva3NEQlNNVWhDM0JVemM3WUJmYzZpZWFnbFkxY2hWUk0zUzh5cDVtQzFoTitXdXJESWs0L2pYajczR0dFR2s5CkJiaEJWWFlvUjZVTlVaSXdKanlBWHNzV2EzUUhxVGJZcGFvZUsrMVpRVmtNbVVaaU5JYzdtOGRPRVI2YWJmWkkxWEhieklCZjVXcnUKR21XbGRHZlhvRTVMb00xS0pXUUMrZlJlWDJpQThLUkoyYmhFQmdWdDNmazUxb2hxZk1vcjB6ZWdoZTB4eVRDcG5UZGMxTkVTQm5WSwplUk1uR0QzdGtiTGZmM0xLVXVQT0JzeWxFY3piTlE1L2JreEhuNi82MTY4Q0F3RUFBVEFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBCnJOVFpSc1BQcmdYa1ZKSk4wbXhWUWpWSjNFQW1lcGhTMlByT3A1MCs2NThvc0REZlg0UzBGRUplb0ErQkxLeEJwZ1krTXA4ekltaVUKSVVyanZYeko5amIrUGJ3cEF4Y3VTdlZNakxkZnVGNHB1MEQrMFhjTE1vY09zMFZGY2dBcnFuMzIvZlNMRDB6K1FLTUtqNldNR0JVSApLam1Xak9hV1lmZmZ3cFNWeWFkSVQ3aDRGR3Bpc3JSR2dtRHFJTnZYVlBGczFEZG8rd245dDgrdW1TRUV4b2dtME1SVjZJS3NrKytwCmFlY2RPd0gwdURhVlFRaVg2ZUdkMHpXbGVWTmVOdm1WOElwVlFSd3RXWTNkZnhjd0JEZE5vVVdVVXJGZzcvblRacHFyejBGMTlERmgKK2E3UTlFUFpRNDVEM3FNK3Z0eDdWbmlrT0lMd1FXWEtURng0VlE9PTwvZHM6WDUwOUNlcnRpZmljYXRlPjwvZHM6WDUwOURhdGE+PC9kczpLZXlJbmZvPjwvZHM6U2lnbmF0dXJlPjxzYW1sMnA6U3RhdHVzIHhtbG5zOnNhbWwycD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOnByb3RvY29sIj48c2FtbDJwOlN0YXR1c0NvZGUgVmFsdWU9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpzdGF0dXM6U3VjY2VzcyIvPjwvc2FtbDJwOlN0YXR1cz48c2FtbDI6RW5jcnlwdGVkQXNzZXJ0aW9uIHhtbG5zOnNhbWwyPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YXNzZXJ0aW9uIj48eGVuYzpFbmNyeXB0ZWREYXRhIElkPSJfYjk5MDQ4YmIxYTQ5MjFkN2JiYzY1NWFiYjMyZWM2YzAiIFR5cGU9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI0VsZW1lbnQiIHhtbG5zOnhlbmM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jIyI+PHhlbmM6RW5jcnlwdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI2FlczI1Ni1jYmMiIHhtbG5zOnhlbmM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jIyIvPjxkczpLZXlJbmZvIHhtbG5zOmRzPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj48ZHM6UmV0cmlldmFsTWV0aG9kIFR5cGU9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI0VuY3J5cHRlZEtleSIgVVJJPSIjX2Y3MjMyNTRlY2M4NmRmYzZiYjk4MGU2YzQ1YmE3YjU0Ii8+PC9kczpLZXlJbmZvPjx4ZW5jOkNpcGhlckRhdGEgeG1sbnM6eGVuYz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjIj48eGVuYzpDaXBoZXJWYWx1ZT5pVGVtNHc2cTVkcGpUUERvc1lLVllVRUJKV3RpTFVIL1N3d01iNEorbWNmQldQYWhBdG55cTdXdCtGSGFJd1RPWGRuV1VHQTliK1ovaVRBVDJpSHZWY01VL25ReWNwMXYwTURzbEx6S0VhQUhSdlUxZVdmOEVGbGdFZytENU0rZmhsd0FvdFQ1bDRpQzlveXhibGpZcWd5bUlZQmZiUHlma1F1dUtTTzl1Z2UxeW8zTStka0xBWUNvQ05OeVVYaXUvQ3BCWWNlMEo3TG5EdzJxQm1CY1FTQzVoQXlpSFR1VWxJVENDMXRUenRTTWRrbzlVZGRXMWtkaDZwbTYyNStsMWM5Um40VkN4TDNpdEhjTk1xdTdqY3llempBT3BET2lsbnd5L3VtdUhEZGNHbDVtV3o3eFo0TFJoaDBsaFQwM2pLVHhvQnJpUkhwUXljZFdvTXExM0NuaVBNY3Nmdk9DWDd3R0pJM25ObTNVUWFNZkkyeGZiTHRnV3Vkb01yODA4cy9PNzBkZ2Fzb0llVms0TkJqVE9BK2FJdGxuWnA1a2piaFdFMGlJWlFTYjdpRjVtYmxyam1KcWk2WTJFZFBuZ09FdEtGYlV0b3o3dHRWNmhiSXUxMnlYb3FHZ29zNExoNi9uNXBoRGRnZ2t0eGpCN3ltUDQrbTNkdys5ZzBNMEQxamg5MXpQVHdsNzNIcHJOZ2ZaUWVJZVV5U2FmdzdvR0tGclZEbVgzUUNSQ0hxa25sYWYybitrdmdocnQwZWFxbUZuTHNuUGVUYkRlQyt6UzU5cXc3VmpkWmFDdkxGUElSOE1pTG9hYmtieldBcW9iUjhuUzhOazhGU0ZqRVY1ZGlZR0F5WFFQejQrQS9ON29ZMnI2cGZlVy9mcGFzNVgzdDREajcrdXdIeXEzcnd0MlZxaHYwcCtQNndJeXJ2VHczWFFJVEpSeVVXUW5keGhBSmRnWC9NYXNWdjBOSW9uN1JIdDNYaTBibjJ2cmNSdHVqNTZHYmtoRGFMKzN5NUZYSkxmelVzVU9GZ1RwYTZCeGcxWUJpc2I5bFFYU1RReWk0V20xUHhTTSthL3VDK1dKUmp5UDVyR1VYbkJES29xTFVsOUZhM3R2ejlialY2WnA5aDdsMzNzWnovbzlHNGl3c2FWc29mb25uREgvN2VzazV2ZE5RTkhzZktVVnZJVnZUTlpRVk1zQm0zSlR0eE9TekJtR1lqaUdIbjBleHovZG82ZzNCQVRSQmU3cm85VlRUY1RlaUhRRGJUNWZxbVBuaHA4Vkp0ZjE5UUcvbXdadURYd1E3VEduQzdpVlMwK3ViRm53NGZaZUJtcmkwRmh2emdRNlNGdVFlL21pWUtkS2h3L0VWSGluNTVLVlpYdjB2RVBRZjBYQnhlTC9iU1hiRFltdE9aNXRHZytTMnVjdk9MOWRuQitKejVVdXA2QmhPOHBKUXZUTTcxeU5VdElmOGZVN3BnUTVjMmc0cUYvVmRLWjhTSll3bWNPVEhQNFhxQ2dBQ0lwWmhvN0xMOHFjRHk4OUwvMUx6eVlCbDg3SkNyYnJPSnFhdUlGUS9KTUpOdGI0MjRBeHROb041VTFucUgweGx6ZkwrQStvS2N2VmFsL0cxdFcxRXczdHV6V3BGYldBdDdhSXh6dHlraFJla2NnRkQ4YUkzdC9tUGJ2T2hEaWZwQUVKckpLUGlYVXBMaFBTdTJ5ZVlKdXJKeGJiVFVtSXNTbHFOMUdpWjhDejRyVzdQL1N3Y2g5Skc4ZFo5aExIWVRsai85SmY5U0hHRHlGd0x0ZjJuSlBtcjhPOVNwRmhxbDNnWGI0UHc2Y09nZDRUSzRDMWRidHEzcy9RRnZDTTg0b2JwSWZ1TDQwZHl1MFk3R3RpS3Z5cjg0eGwzWXJvaXhuWWRwVk1McHM5UUVvZ05QSjFDaGw2VEdPcHQ0bVBEWVRjcWR6RnNFNXVJQ0xzSEd2RnIvQngyZTJZVURtT0ZtdlFwZDVGOGtSM2NEU1lITnhMT1RuMjFKNXVVMHNLcHVvZGVhY3c0SVZ4NlN1T3BaR0h2RTVWbXZQYmN6eHdud2Y2OHhkTWlLNlJ3MTNtSjNSaGt4QlFBTk1TbG9NR0hhZytqN2tKM0lwOUZzanJZU3F1K2U4dlFqMW9seW95NlRyWkpSd002bmovUTJLY1NhVEZUbk9pRHVpZUdUeHQ5S1pPU0QwbFM1U256MWZrWDN4SkFTbnpuNnVWbW91NXIyM3NGQUNOYklmbXlUT055Z2NSbXlvRkF4VTRLMHMyeW9KeGRDWkFwUjFsYWlvL3F1NmFudG4rMlE0V2Yza3Y1bTFxSGEvMWNGam5scy83aGttMEtleWJOdUxuMkNSZjlPZW52S0ZhSkh1UW5ZRlZ3TkRwcTBUR2RNWWxrMFlndzkyRFNXUkNFWkNmVVVrOUQvMkZRK0FIeXJZOFdQcDM0UkNPRmRGUEUvZStwc09ZcisraVB2QUo4bVdpNUpjT0pIZ0dDWnVCOXB3TEk3Z2VLQWZ6eThGdHlpNTBzYjdKT0RLNVBXdzVmWVdONlZRQTJmY1hmdHdaeW1NZ1ZsT2lQM2RYM2lwb3FrZU9iM3ZsZ2FDMVpQK0hQUWh1NC90RWxIYjdRdVllRm5rSlhlQ3p6dDZuMHpLRXY3ZmZWeVVBbFdtRTJmVVdTU1dTTVBOL2g5eUNpeDF5SUhvcDMzZ2c0c2FJL0hIYUZzUVhKR25PZmt5S0VsbHhBeStmdi95WjlQS0dYbVpRbzlubWZCaXpNc242emozRDRsdHNpbEt4bzltNXpKdUFOMjg5T1BlcXNoRlVINkpnN2pjWFkybWRJSmtZamhtdDRoWXZVM2h1OVpPVG5LOEY4L3M3VjdpeFRtVjBGSUwrSTlxVDFoeG1mZ0k0cDJGVEdFR1BIYnUxZk95NnlHWWtMNVJ3RkFoaE1ycUpsYk1zQ05rN2kyWDBrdk42TEFvbnU3K21EZm1ERjVHUkR1QVk5MTloMDk4a1VkOFh2YXlmNzZ3K3R3Z3JGcVQxSXlLQ1VIMEtVTFUwMTFTL253ZUJnR1F3d1g4WWxoRW5uOWhCb2ZGZ1RLVEE2V2sxd05QT004S0s4WGJ5RDdwNjlleUdZenpEY05Sdk95aDFrWHB6NzQ4Vnk3V3pOTHpVM2xpWW15UnJaV0pHdTRld21jb0xiMmxCbEJtTFRTWUVQZWd1Q3hPNmwrMzNmcEVaQ3B0UGdMcHpkSzIrUUF2VkZWN01OTUhVczNsVWpLT0lOSjIvcTFVVzR4QlM4RWtLU09ZWlBicGpZMlJDOFZOdEEvV3pDVmpYS3l5TkQ3YTh2blJtSGd1SEJlenI5ODFHVFloY2t2ZGxmWlh1UlFoQWEyT0gwVkJNcWcydkxnK1o1VnFHaXFob1ZBczZoeHRneXZnMG1rNEt0YlhXamlJUmZGeldNcDlUZzlraWllU1JHQUtsVnNpdWtlMnlVRjZnMVMyenpxK2o4eG9YZU5oRGRUUU5GVDAwdldpUlVVQWdIK2huTWIvTlRsRmtVM3pKL3E1c25mTjFwK1NIbTZyYnRDUHNWcUJGRWFtc1RVS2hOWTJ6ZGx3WllMemlxVEcreEh4bUMraEhXTElTNkQvSDZkSFRRS052N0E2M3ZBT3E0N1pWOS8xZStXSEw2L2tsR2dWUE4vVlJtWE92SndDb29vTHE3a3NocytOWit2UnQxNktWSFladlpuQUlKengzYUI5dTB1TTBRYS9jVlkyUUs3RGRuWGpWQzZjcVI3ZHVGQllSUDYzT0daS1NvczNjNFZtVmhHam8yQ3E4ODRSRFhrSTdIRzlmQWtLWG1MOHdIbEMrZyswNUxwRmpuZFVseVlVdmVSQzhVNkZScHhHMUlCV3FzYXlxOTR1c3BHeDNxMm1OZ0R4SGgwK2Q1MzdZc1VkTHlUYjlZSTJqbUNwelZXbUZHbEdHaEFkOFdTTzNQOS83ZXhKenFCRUgwdW95OVRUcWtsSTdyUWhyQXorNnU4NWVJeTVPMFJXNzN3anc1RisxQ2tqTVlHeTlJK2ZwT2dYL2JaTlVCS1BKMnVFMHUxL0o3L0g2ajBYSE53blNFZ0xyUW9iQVMvajdtSkZSclZlbms2K3JrWkw1NDdGR3B1M0E3WGFZU21xTkZmaUZMUjJpSjU0YW1PclRZNzJYR293bWtUQkhjOFh1VHhQcE0xaSttclNyejRheU1vcVp3R0RWQU85VWI1Z1pabUYyK0RQTER2YTFycTBlTE55KzhwLzZZcEF3cEVqcXBXeW92d3pVdGR4Yks2eldqSmdyMU5pcGdzM3BPNGJoVjZDSzd1Zmw5WlBIQU1Fc041KzMyY2JlQkVpVWFTbVNMMFVlVWc3bkpHNU5VVmxNNmViWS9kbXU1NE53K1o0SG84d0NBTjlad3BpZFVPRXk4NzZOTG9LS1B3a0JUWmJ3ZkxaVkYwTmpCMGo1ejFVVnRhU3licEFYQkFJUE42bTJpM2xrUzZId0orM2djQnpsc3dadGYzSGlIdk9TYUN5SUVCQlhRK08zMVhMTXpSTGViNU1hZGhwTmhqOTFBVWRRSm5xR0xLU0Fma2Y3cExJTUJqYjV0c0U1QklPS0xnTEt5RHRFL1l6ZXRseDF6L1ZnRkE1SEp1dStYNFg3NGNqOXEwYWhwNFJWS3k2NGhzSXR1YWJ5bWZzNUpFRlNjRlZhZkNNbEMvaDEyei81cTBBYkQ2cDlzVThRSVRIWDZ5WjhEdDdNN3dMeG14alhpSEc4Y1YzOGNlbFdpNm1KV2RUR0hpVDR0OHhFN2EvL0FMbjBMYmNqZmUxN21TaXZ6Wmx3YWZDZTErSmYxbi9qOE5XZ0RRMzFLRjgwbjJ5R2Z5V0FKRVMxaVExOEFRQWc4S2VsNVIvVEhkQWViZFF5cDhSanVJRkk5NkRLbWZLWFltNXQwaVBHYVJTU0FpRkkrOWFvQ01hbWE1SGl0VGdWSzBsNWcycjJ0eGtKekp0VkdlQzY1ZUlPTFVBenBGOVNkVjg0U2xDOS9CeWpJNjBkTmZueDlkUlhPM3o3WXhjRjNiTlpKdW9GN0JOdWRKUzdkelZkcGRQWWRRV2o3Mlc5cU1HeldhUzB1bXZ0djZTUXkrNWJwa1QwNnBxbjZ2djVOZGNlYnB6Wk9JcjJNTjg2V1FRSFd3ek1KbW9zcUs2TkNmY1EwWVhWYzZvZ2ZyWXAyckhkNTlNQVVsdzRSeFZkLytRc0o4cS9qSHhKcFJZVmV5WDlaY3h5Z2RQZFpzQUdkREZHTUZncU9QUTBxMHRTMEdRMENaQXl6MUVUckJoeVp0eDF1d1NuaDhKVE9XSC9EQkZwU1dMV043WlRuUC8wQU9qbkNPV2xqWmNGVWxGMFpmTnpFTUQ5eC9saG9DVHR2emxXaDBibVpESlYyWHQwZldYMFNMVUMrUkhIeDlrU1BrRk5IZU9wS1JkanIzYnlNZmtPYlhVMnNUckV5SHUrMmYzYXpJWmYxZG1VRXVMTmNVVkhMbjRMT1M0dmVWTklwQjVWVWdiZ3pmOHVtYXQ1Q0hhaDRISzNQemlEdSs1QzhmMjdnQk04MjJaUHBhekFvSnJna2F5UHFOY3k3cTRKdEVFbW1iMkY3Ym5sV3ArSXhOK0JSTlFubTJIWkVlTlZyWFdzVUxZYldYekxzeEt2RkVYSnRTZ2NYVjVxeWgrdjBiUnJuUk8wN21ZUy91K0pzTXJEUXpJOUJrZDJsYW1ZY2M2WS9US2FOSExCZWV6akpUbkZ6K0dFckYxeEg1MWZiSW5WYTJ4NGxmR0F2WHZKMHVSMW52U1BObW44MFBDNkp0ZVVZRXllT3JXZXhwUFBSU291VVZhbFNweFZIUldVNmUyQlk5ZW40L0ZCcGtuSTgvMWxUTWxzd1R2RlNDa3FwZkdFOEExSC9UTUpvZlIxRk1SV1hxc09tZlp6d3VYNzdOQVpvMjVrZ1FwYWNnQVV3NTR1cGhoRkc3d2YrS3ZTbXludmNnNXYwS3lnL0o3NXdueFdOY0FNUE5RR2VLNWNUY1NpSk5oTy93elBYS1M5UndkaW4rM1VRM1NGSDg2bklESTE5VjFja2VVb3lJc3djdm5zNEF1ajBleUVsOE0yQ2JOaUFpaDl6ZGhqRitOaVJDS0cxTUNaOXdqT0NITTZQSmgxbWlCWmhoUmIvYVU0aC9pZ1hhRGJvd2F2SjRwSEFmOEI0TkxMbmZmdi9oTis5b0RIMXAxTkNvRXFLTDE2Y1B2MVppcE9HZGJlcHdTdXRLckcwTXhLMUZQMmtudERqUks0cGlMbWQ1d05QbEF6SkUzR2Izc2p0QXVnMzdERDBNZGhja2tQRS9FSnNJdStoUXlubEEyd2xvL1dWQncwc0h3ajRqaFhqeElBa1NucG5MRmVhRTRNWDZGVDMxZFNmdk1FaEQxbkpDKzU3U05nT1QzbnhKeXdSaFF2YXJFOUpWdTdNTDZsZWxhK2NNTG43a1VJdUdnNitBRTI3YUl1SEtabVpZYTB2N0RUZ0FHOUh2ZFBlWVF4OU1uVlJuOXhqZ2krOEJBVEFhaXhPa2hzSVkrUmtYYllxaVlZWWNTMGw0OWlJbjE2bFZMM0VFVzdDR005eGNVUm43OWYxamFZTExXYnAxYnlqemxTMlNwd05YblBDVjNHYXVWcjdqbGNydlhNR1JxZW1ycmYvZjR1KzlER2pUaGRCdDE2SVlURklOTXBLV3NQZ0VZNEY1ZUdDVVhWSHhJMFJ5NDZ2WEFmdkp3Z0lWN2lXcU4vQXQycnNEeG12c0RrR0oxNHk1MGJ2SFRoSEJoVVFLSkNpRXN6WTRzNlBxLzBvVlBaYUZqWE9sN0dxYWtXV3hhcDJqMWNMemRLOERsUllaM2dzSGZ4UEFjNUswNTc2aTc3SHFlM3Fkc3U4VUFUNGRHMlp0dGJ6V09SK0h5YkFkR2x4eXcxRFJEa1EvcEZpOUg4dHBaZGRIWU0rTVRSa2lXK3FSSjUwRVhHMEI5azBPS2dHS2JYK3djbXd2RTNPSEt6eDBJNFF5bGJqSGJNQzhSL3UzSm0vcm9sMkE4YWg2djIwTFduOWxwTERuY3JGR0tRcnp0OTdTcG5oYTZXSGcrU0ZWVFlrQ0k2WVppdWtxNUtiSWpTOUlBbUNpZk1LNXVvbjhEcjV2cHBFYktIVzBHTUkyR2N1TEp1MWtaSWFxSGl1UFp5WDdVTjg1R1NKY1BQUVY5Ylgycm83eVkwR2tkbitXYXQrVytERDJFdGZudDEvbHVnWDBNM1M3d0x1dnNjV2VkTVVFb0thekJ1K09LcExZZjBReXlwdElCSUJRdC9XcGpCaWt2QTRsdEplNzFqRVpDaVQyeURHdXRkejdzNGt4cGlxK3l2M29zYXFPTHNsMmRYemMvVkJDLytqejVrSms2WDY5TDVkYWowMmFGMDN4eG0vTjArc3UyOFlWVFVZSnFvV0g1cUFpMXhaQkZNWkU4Qy9NMGZ4U0MzZnNZdEZhWWlmcWI1NHAvWE5BRkJ5S24xWjVTbzY4d3FYcnRBQXJmV2FyQVh4ZDBWbjFUa081d3V2cFRMd2RUdWtCL2pUby8xT3J1OUhJc1I3MWdidjJwRzF1Yjl6VTk2eUczWGhybUNtZmNDOWZsUHJPN1RRMGpCTlQxaklzTGVSdDYxV0lCYVNJaVN3VWtFU2ZMeFVSQm5mcEtnZVJETlpkSHFXYmZ2akw3ZjIvWGswMlVuR1RWOUhzM1FiTVBsa0tOM0pKcC9Id2owVzNyb0JGQXB2cndPYmRMMUs2MXhhQ0pvWkZSRWVDSU5xcnhGb0xyV29zRjhXcDJXSURiSDJ6KzFtWTVvWGN5aFpBVXk3UjBpK1RxQ3FuazhyZUNxcVcvejBEWWZZOGpJVGViZzhDTUVjZzNXNDk0TmkzYXRZd3M3N0dIUmR1eGxQZ3FjSHB6NUJvK3c4QzFrQnVUaGE5SVpQYjNjYmwwVDdWN3RpQ1czQjZ1VGJ5dSthSTA3U0t4VUFzMy9rRW1OeEEyb0FoWFZrTjQ0ZFZucU9CRFd0Zks0RUtxL1JqUVhMeVFPL0M4VTBmRUV3cFZCWVNLTm5xemI1bTFzdVVsVERMa1BFZDMvSVVDNnNQSzRXVk5oQjVJMGhFV00xOE9mNVRwL2hENXhHc1NzMGNjTDlxandLaVhMYkY0Smw0SXg4bmxhU3IxVlpkcnAyb000NlJKTWJkWnkwOWNsR2g0eG9nNDNuRjRYcno5bEdGWXYrQ2ZQekF5aXJzWU1YNzExcWhFRCtBMGkrK3pjYXRBQnZtZWJwN3BPT0dBNFdyOElsdmNoVGRLeUhGVE5OOTEydGpZOC9hazJ6UWYrWTFzRk1IcklGWHlRY2RtQWRmUEovOTNOcm1iR1VTb2NCcU5OUUhnZ0lXK0ROeWI2SFoxYy9TWk1YdlJWek9TVVYrWUtBMXc0eU52WFI4cEpLT1V1MEF6WVBjUFdINkN0QzlrdVArdnVQUnJBL1JQbytqVWlGTzB5ejFLaUNOYTVQRlpLa2dLRncvSnVsZGJDc3Y1dXFwWGZuV2xkVEh6U0U4cTduQndzOWlicWRaUXQxQmtReGxKUTNZZWVmRGhnS3NzZm96dzJPT05VV3I3LzhlMEp2YXE4YkZVeWRieTB5aHJkNm9LTzBaMjYyUGdDZDFIV0Q2SzNEOXZSRUYraEhCemh1b25CTnVUa0FxYWxxTURaZGVrdnBWa1J1WlRoa2kyM0Iyc0NrbVBnL1FjczREam9vMjRpQmRZTVkxcGR0OFJSYWdRdVpZNldnQ2RJQTJlaXdiazI1bW1GbHU5akN0YW1lS2lLK3pOTXUva1RoQkxoYkFPYnRIb0xyTDZQa0NCdktJZFNiZ1g1WVlmaDdiTUdmbGZmRGtOZ0RVU2dLblhtNGtjT1FiUGg4a1BPY2sxWDdjcGFJdVZaWXl2WjNDKzVOL0Q4Q0FKc2F2Z05YQis0b3pObHlSYzdwc3JyT3BMVFYwWWtrK3I5UnI0bWJ3Z1NoWG1peDhQcFhGa2lUcFZLT1N0VGMxU2d2YjNCSGxscXplK2R0WUZBRHBmdXlNMW9sS0FkcUQ1dE5mLzFDd01TcThDVDVzeW9XbEorWDMyNWd3QTA4bDdEdW1jMUdRc3hOOUJJVjZTUUwwTGtUYU9ManBtcG9maEJORGNlZGg5YzBPQ2RmZlptaXdSYWRpMjVnPT08L3hlbmM6Q2lwaGVyVmFsdWU+PC94ZW5jOkNpcGhlckRhdGE+PC94ZW5jOkVuY3J5cHRlZERhdGE+PHhlbmM6RW5jcnlwdGVkS2V5IElkPSJfZjcyMzI1NGVjYzg2ZGZjNmJiOTgwZTZjNDViYTdiNTQiIHhtbG5zOnhlbmM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jIyI+PHhlbmM6RW5jcnlwdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3JzYS1vYWVwLW1nZjFwIiB4bWxuczp4ZW5jPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyMiPjxkczpEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjc2hhMSIgeG1sbnM6ZHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiLz48L3hlbmM6RW5jcnlwdGlvbk1ldGhvZD48ZHM6S2V5SW5mbyB4bWxuczpkcz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PGRzOlg1MDlEYXRhPjxkczpYNTA5Q2VydGlmaWNhdGU+TUlJRjB6Q0NBN3VnQXdJQkFnSVVUVlVEQXhIZVRma25oOUp0eWlqL1pDV2FaRTR3RFFZSktvWklodmNOQVFFTEJRQXdlREVMTUFrRwpBMVVFQmhNQ1EwRXhGakFVQmdOVkJBZ01EVTVsZHlCQ2NuVnVjM2RwWTJzeEVEQU9CZ05WQkFjTUIwMXZibU4wYjI0eEV6QVJCZ05WCkJBb01DazVsZERvNlUwRk5UREl4S2pBb0JnTlZCQU1NSVU1bGREbzZVMEZOVERJZ1UxQWdVMmxuYm1sdVp5QkRaWEowYVdacFkyRjAKWlRBZ0Z3MHlNVEV3TVRZeE9EQXdOVGxhR0E4eU1USXhNRGt5TWpFNE1EQTFPVm93ZURFTE1Ba0dBMVVFQmhNQ1EwRXhGakFVQmdOVgpCQWdNRFU1bGR5QkNjblZ1YzNkcFkyc3hFREFPQmdOVkJBY01CMDF2Ym1OMGIyNHhFekFSQmdOVkJBb01DazVsZERvNlUwRk5UREl4CktqQW9CZ05WQkFNTUlVNWxkRG82VTBGTlRESWdVMUFnVTJsbmJtbHVaeUJEWlhKMGFXWnBZMkYwWlRDQ0FpSXdEUVlKS29aSWh2Y04KQVFFQkJRQURnZ0lQQURDQ0Fnb0NnZ0lCQUxKQW8rQU5tUjRZWitWeHMrTmdOU2FhMWhWWlZ1NlFCeDRnTjY1MTNvak9yT2JkWVEzdwo3bXZNUzJnbDRPaTVrYUVwMVFSRkx0Nm90T25icW1aVTRhUjdFb3dUVGZNbTJEUUZUdWpSZWoxV01mU0gxZW9PSmNWRVBXeTczQjZCClZ5UlZYM1FqYng4blZoMW9rNk9oVGF1TndaUHFveHN3MjZkMXpxYThrR2s2b3JtY2ZzdWtRdUdBcnhwTUtOcU5NTWZzSzkySFk0VUEKSC8xdnRQZ1o2a1BzWnpTTGhVWGd3OWZRcnN1Q1VDY24yZkZCQlIySWo1bGtid2h4Z1VBc2ljcHFLb3V4VzVuU09XNHFzTnIwKzNwUwovbWs1K2w1b21maUZhcHgwQjlEOU1xOGI5RE5tUnFvZ0JJMExiTUUzUmwzMlZ4YVBUaEx3OTVlc013Zys4L2FJZDEzTWtTVUxSOUlBCkxMdWVSR2o1YlpKVXlvcE1hSkY2TTgrbU5kOFZXUjJPbnV5M2thVFdDUjVRZWZ2ZWdzMHZzZmd0dDErekhzTXpwcXEwOVVCTUZVUGkKUnRoUkREQy8wTGh6OXNNeGwyanhNWGtVWW1sVXk0bDVQSnQ3L3pPeXArOVpnUGRyK0l6ODJhRnhQUnlNUTFwR0JGeGhIZGtBQVdTeQppajF0ZWp6bWlPNi9JV2hUYTNPL21QdVFjeUwvSXpUY2dyWFdSMUp6MHhmSFVmTXg0WWRMTXVKZVBCLzZUY1JxTnRVbzRsclQzS0t3CkQ0VkZzTm80V2x0UmlZRkNuYjBCQ3RyQTA2anhMLzBHNEJrRnozeXNtYnBNc2dlSzhhL2o4bVh1cW5EWmVDZkhpcnRzZzFMR3E3YXgKeC8yRkgrSmtCMXVCcFJLeW9TVmJ5YStIQWdNQkFBR2pVekJSTUIwR0ExVWREZ1FXQkJSQzc0bGhGYWxGSkRJL0RzR3VhQkk2WEpLNgp5akFmQmdOVkhTTUVHREFXZ0JSQzc0bGhGYWxGSkRJL0RzR3VhQkk2WEpLNnlqQVBCZ05WSFJNQkFmOEVCVEFEQVFIL01BMEdDU3FHClNJYjNEUUVCQ3dVQUE0SUNBUUNreUx2ZE51Z0lOUzduVlp6QlJKL2lDOUE1QjNaaDhlVjlSNzd0U0xJSkI3QmM5T2hDa3hRV3dIZzEKKzVGb1F2VWhBek1FSnJzU0NzNWJYNnhrdXZ6NUZhUDZ3K1FldWxDdDBPTlBoakhFWUorQmN4UElISGlaWFhmRzUyYWNSaUZjRTM3Wgo3NldLamk1OTFJZlpBeTVPMzBKTEYyNUo0b3Z3eXNQbklmOWs0THVWckVQSGxQa05ZZmVmZjUyV3JBTzhxVnRZc2k5eC91ODFTWHF4Cm5LRnlQMm1FZnYrTWVkNEYyUFc2emJUVnZkQ1o5bENzYzQzRFRNNkFDTUFvM0JkOVlTTThYYnYyQis4eVJmVlRHandBbGc2b3BVN0wKeUVpcGxtZXZuRUxSNW8yempqUTFRZTNmb0lwbnl4RjhNUjIxei80elJtT3A3YU00WFhZSElsZ3VQcmdhRE1lbFRyRmZxVTRCdUVSQgpKRUlUNU5xVTFFRW1zTmwwTDl3MHliOWIrOHhIb2RVeVdaOVBQbFpuWmhNT0hpenhPVDZQQ3N0NzJPeGZMcEgrV0xxaGd1aFJHVW5KCmhVTUM0b3ltY1EvcUNtUlFCSkx6NXpURlpzSGY3ckhKQUpJcVA3WU9ZM2IyUVhLSmxFNldzQVB2amFDd20yNk5HSk1NVWJNY05uOGgKYUN3M0FRbXR2ZDkxYzluWGtzdHBsUW8wakVSdGgveUdrSm5SdEw1bXhpM0pQOG9MOU5JaCtrTU1lc0hsakNZa2dVR2k2d3dSVzNqMgp6UGlvd3BIRFpzRExnRjg4L2NqdXE2VWRsZU5hY0lzbmdDeEV2b3NJRVBCUHRQajAzaFVEbDRxS1pDaWYxU25kY1NJOWFFaHoyMWFWCjF2Q1pqeU9aVGIrbVlnV1V2Zz09PC9kczpYNTA5Q2VydGlmaWNhdGU+PC9kczpYNTA5RGF0YT48L2RzOktleUluZm8+PHhlbmM6Q2lwaGVyRGF0YSB4bWxuczp4ZW5jPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyMiPjx4ZW5jOkNpcGhlclZhbHVlPlMxSHhyQlhFaGNrK1VFdENqY0dEdTRib3dSK2hzNE9IcjFIN28waUE1QXA2M0ZOVWpmYTVLWXF0cWNVS01pQ3VoNVlnMHg0V1k2N0lzL3pvTU9HUUFmTVJxNTU1cWhQVnAwNGFOcGlGQ1pacXBHZjdCMFlLdVlRZ1dOR0d3b09vOXNFT0Nhb1BkUm5qMmp4RWNuOUxRUlh5Y0VNUlFMS0Uzem1aS1VyREhwRFBpMGEyaGNKYS9IMkQxd2ZDS25iNDlWR3dnU08rUGwxWUx3KzA1b0UzUXM3dkpwSHN1ZFpnZmZqVWZWSDg2Q0FVMnAzNy9lbFVPNm9UN21LU3RXRFZSdDdVNEtiZG41TUYvYVNVeUs3V1hPUUxEZDRIelIxUEgybE00ZTJyeEFTSzIvM0IxUnZ2UlMyV0s4SDlPRVc4LzVONHNIeUd3TGRSenNtTkxBVnZMeVFJV2ptLzBOYkpBMTZLQzN5VVg0RjNXVFoyR0hqL0MxVVNKWmNiNmtYQURzRlgzWHJ3dG91c2pGN25yeFdaVjZWbnI3RU5ubUVjWElTUkVWajFOMmlIWmE2YzZKNFNibm5PWUtsSS9OWElyOTZpU2lDN3lXOU9ac25xQkFpWTdQaEw4S1RydGQ1Sk9GYU5BNjFPOGpDSnZMMGNUSTBsaTBJcTZkNk5yN1ZJR2RENm5HdWlvaHd0MEpXODVqK1VNbVU3bGlDcWQyTTA2Ri8zbXRzWHlNdW9Qb1VBYUJDM2FBbGJJb1BINVVDdnd5UXNobFFHRm9xWU9ISDRVa0NlYngzVnpZb0ZUUm5SaGpLTndobnU5dmFqYk9NNlNNVmN4VTdlWkVSNzBxakRaZC90QTNtaW94R3NzdWJLVzBFaFRFYys0U1QyMlpDdVJtdXM0YlZFQkcwPTwveGVuYzpDaXBoZXJWYWx1ZT48L3hlbmM6Q2lwaGVyRGF0YT48eGVuYzpSZWZlcmVuY2VMaXN0Pjx4ZW5jOkRhdGFSZWZlcmVuY2UgVVJJPSIjX2I5OTA0OGJiMWE0OTIxZDdiYmM2NTVhYmIzMmVjNmMwIi8+PC94ZW5jOlJlZmVyZW5jZUxpc3Q+PC94ZW5jOkVuY3J5cHRlZEtleT48L3NhbWwyOkVuY3J5cHRlZEFzc2VydGlvbj48L3NhbWwycDpSZXNwb25zZT4=
SAMLRESP

$xml = decode_base64($base64);

ok($xml, "Got encrypted XML");

$decrypter = XML::Enc->new(
    {
        key                 => 't/sign-private.pem',
        no_xml_declaration  => 1
    }
);

ok($decrypter->decrypt($xml) =~ /id31558763884313921701017518/, "Successfully Decrypted");


$xml = <<'XMLCONTENT';
<?xml version="1.0" encoding="utf-8"?>
<PayInfo>
  <Name>John Smith</Name>
  <CreditCard Limit="2,000" Currency="USD">
    <Number><EncryptedData xmlns="http://www.w3.org/2001/04/xmlenc#" Type="http://www.w3.org/2001/04/xmlenc#Content">
 <EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#tripledes-cbc"/>
 <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">
  <EncryptedKey xmlns="http://www.w3.org/2001/04/xmlenc#">
   <EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#rsa-1_5"/>
   <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">
    <KeyName/>
   </KeyInfo>
   <CipherData>
    <CipherValue>NKwRJ4AT2nNz9507cB15n8tROCpupxIS5HA2MPyQ9syPq8w//7mTkZ3XUN2IYvbz
mBx4jng7hIFUhXY54K+XTobVBugvPUOIcV6Odt/JUnkLHUS4+X+ef2vUDQaXjDw/
TacvHPeiWj9jkbQmWfnyZAyKsZUmRWGrEYUgdNTBDsVhpgMfW8hVkSe6sIWe+tr+
4HaygBwiJpWDb07ieQr5zFkvR7Yp80BCQ7Ewjjvilqn7jZt7V+Kk5API8nFP9AYC
2O5YDSW8qFJOXi64yejWO0lCAxZ+PHv4SNoZqsZJwpM8thuoxJ1X8Go5U/BsMsas
lBOPnjES+ZKBErB8KeOCJZcyepf4tU2xpNT62OdeW7oVV0U6BtpO6Cwb68Xw4oO5
wMz4BFH439q6hJaoMtZRjVGvpaIgb6eBI2wgU/x1uqYK6aRGXhgDOIpxgCCmXguG
F94RnhuGh9K4d5n9+lQ5rlFWQhzZy+5PrK6TMu+PS7eKtFrdhAu3jamJLGtbLhO5
tV3DbY7nTjXfd3STKZ1ndYcRZ/rFrtsEypUxjFuu8G6jdWnXKTI3AkV/Ol0m1Dj7
4jZ4Uzv1vTyt7R12Cq8pzvSusK7TwNjEiK4/HZpwop8gTNac8ZSYd/mjWi7WDqG0
73zwhyGQMiGBx6T7mXJB/te5XX+vXJq8cNW5ZHXC0+w=</CipherValue>
   </CipherData>
  </EncryptedKey>
 </KeyInfo>
 <CipherData>
  <CipherValue>efzvgtcIMNdK2s/PpipUP7slwyiu7NMLxLhSz9ACYJ4=</CipherValue>
 </CipherData>
</EncryptedData></Number>
    <Issuer>CitiBank</Issuer>
    <Expiration>06/10</Expiration>
  </CreditCard>
</PayInfo>
XMLCONTENT

$decrypter = XML::Enc->new(
    {
        key                 => 't/sign-private.pem',
        no_xml_declaration  => 1
    }
);

ok($decrypter->decrypt($xml) =~ /1076 2478 0678 5589/, "Successfully Decrypted");

done_testing;
