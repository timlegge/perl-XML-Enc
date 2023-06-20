use strict;
use warnings;
use XML::Enc;
use Test::More;
use MIME::Base64 qw/decode_base64/;

my $base64 = <<'BASE64AES';
PHNhbWxwOlJlc3BvbnNlIHhtbG5zOnNhbWxwPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6cHJvdG9jb2wiIHhtbG5zOnNhbWw9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphc3NlcnRpb24iIERlc3RpbmF0aW9uPSJodHRwczovL25ldHNhbWwyLXRlc3RhcHAubG9jYWwvY29uc3VtZXItcG9zdCIgSUQ9IklEX2NkZmRlMDg4LTJkNDYtNDY3Mi05NzE0LWM2MzIyNTBhZDg1MCIgSW5SZXNwb25zZVRvPSJORVRTQU1MMl9hNDE0N2Y2MWFkMTY5ODcwYjAyZDM2NjJlYjM3MWMzYiIgSXNzdWVJbnN0YW50PSIyMDIyLTAzLTE2VDIzOjU0OjU5LjI2M1oiIFZlcnNpb249IjIuMCI+PHNhbWw6SXNzdWVyPmh0dHBzOi8va2V5Y2xvYWsubG9jYWw6ODQ0My9hdXRoL3JlYWxtcy9Gb3N3aWtpPC9zYW1sOklzc3Vlcj48ZHNpZzpTaWduYXR1cmUgeG1sbnM6ZHNpZz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PGRzaWc6U2lnbmVkSW5mbz48ZHNpZzpDYW5vbmljYWxpemF0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+PGRzaWc6U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI3JzYS1zaGExIi8+PGRzaWc6UmVmZXJlbmNlIFVSST0iI0lEX2NkZmRlMDg4LTJkNDYtNDY3Mi05NzE0LWM2MzIyNTBhZDg1MCI+PGRzaWc6VHJhbnNmb3Jtcz48ZHNpZzpUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjZW52ZWxvcGVkLXNpZ25hdHVyZSIvPjxkc2lnOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIvPjwvZHNpZzpUcmFuc2Zvcm1zPjxkc2lnOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIi8+PGRzaWc6RGlnZXN0VmFsdWU+clRKTjhwZFR1Mkl2eVEyK3V3ZWRCR3hQclRNPTwvZHNpZzpEaWdlc3RWYWx1ZT48L2RzaWc6UmVmZXJlbmNlPjwvZHNpZzpTaWduZWRJbmZvPjxkc2lnOlNpZ25hdHVyZVZhbHVlPkxETkNGZXlGb0JsY1NpNEVvV1I3NENHQ2ozcEZkL091TC91NkE0S1BLcG41NHRNUkFaM3JpT0ZiSDdlUzRSQlAzSUlFYjc3TmVsQmpsSmZhN2c3eW0wcjA0MlYxbmpZa1FNY3pGa0FLTFBjS1RHdGhINE16S0Nmdk1lZGw1SGlrdGhKcHUxRXZqcGUwamlQaG9JYjNXczNMNHJCc0NCVzV6aFJnNDI3NnNoeDFLMVpqclVSSUtZdVM5OHpGMXNjL0FIRUJ2VFgvRE1yVCtxaWRMbEhaUFk3YVJ2R0ticHZVMmhGSmtRQnpIMjNkams0NHFSVVpmL2R4VGU3UGxqU20raUNsVHFCWnNUNFcvdDVVblpzakRyTDFxQm1hV1BGSVEwMGh5Q3hlNlVSZTFjZ3FhaXBpOGlKWXpPV3ZtWDdidTFNVGR4UTdDR2VWdER2NG13NElFUT09PC9kc2lnOlNpZ25hdHVyZVZhbHVlPjxkc2lnOktleUluZm8+PGRzaWc6WDUwOURhdGE+PGRzaWc6WDUwOUNlcnRpZmljYXRlPk1JSUNuVENDQVlVQ0JnRjVZcXRRQlRBTkJna3Foa2lHOXcwQkFRc0ZBREFTTVJBd0RnWURWUVFEREFkR2IzTjNhV3RwTUI0WERUSXhNRFV4TWpJeU1Ua3lORm9YRFRNeE1EVXhNakl5TWpFd05Gb3dFakVRTUE0R0ExVUVBd3dIUm05emQybHJhVENDQVNJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dFUEFEQ0NBUW9DZ2dFQkFKTUdHNmpyZGFkdy82cm5PQUdtTnRtZElaeTExNkp5b2NLbHNveGcraVFUbFJJMmUzZ2Vsc2lPVzdyWE5JWUhIL2Y0b3pROEY0YmE3R3hKTU5XbHJESkZOMjNEaWo1MjFQVnFKSHN1M1pBOEpPUCt0eE1DTjIyemhDTzZPWWlXeDVQOXdtN3pXVmNmZzNzUzk1NjRMUTRNN0pCUTh0RFl4WTlSTENEUitzTk5kMGhXbTZTcmtFeWdocWJjeE5ZK3JnWGZ4TEJLNWVHWHlYMVprME5MQTVYcVJnNWE4QkR6MW9VWjZPNGMyMXRWT3ZWOHZxQ1V0Y254M2hXeGNCZ1hpelc4cGtTUXBRaVE5NnpYcXVBdkR3a0x0WW5RTFY1R1FsdDZjNDE0QTdVNGRzQVpaQ2M0OTBycW5jZnNqRGZiRk16ajg5cy9XQ3RGRE96U2ExNjNwcUVDQXdFQUFUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFQcGVHc0JPSk4zeEdVdnR4SnFQTTJqYTNnN0c3TGlPSkd2elpTSU9GcjUwYmFlYnNvSk5Sd0wyR0RmWVVUTTFTV0R6NFVIbkdlYnNtZTVUVG16alZPM1lFdm5PTVR0VkM2L2ZZWWRvdUFxSUorY1RtbUYzQ3hkL3RPcjVma2FQc2NCMHgwK3pxV3FnQlpMbzBGVkVDRE10K0RZazFIYVFKUHhzQVhHYWhVbUlJcGZJS083QVV4NXRENzRQUjhYZUhXeUwwdzhqZzFoOG5WdGM0OVA3aDA4U3ptU0ZZMHBoSjlwbExwU3ViQ3NkLzFLTVBPSjBEaDdrWUVhT0pPT1d3akxnZ2lobzVONEtCeXRwdHM2SElqbVBsS3ZWN1VKRUFtUXlrdWhPNlB5RmZHandYeHBZUlR0R2EzZlpRcXU2Qnp0UkhEU1pRZmMrSzA4VlRtQWpyaXc9PTwvZHNpZzpYNTA5Q2VydGlmaWNhdGU+PC9kc2lnOlg1MDlEYXRhPjxkc2lnOktleVZhbHVlPjxkc2lnOlJTQUtleVZhbHVlPjxkc2lnOk1vZHVsdXM+a3dZYnFPdDFwM0QvcXVjNEFhWTIyWjBobkxYWG9uS2h3cVd5akdENkpCT1ZFalo3ZUI2V3lJNWJ1dGMwaGdjZjkvaWpORHdYaHRyc2JFa3cxYVdzTWtVM2JjT0tQbmJVOVdva2V5N2RrRHdrNC82M0V3STNiYk9FSTdvNWlKYkhrLzNDYnZOWlZ4K0RleEwzbnJndERnenNrRkR5ME5qRmoxRXNJTkg2dzAxM1NGYWJwS3VRVEtDR3B0ekUxajZ1QmQvRXNFcmw0WmZKZlZtVFEwc0RsZXBHRGxyd0VQUFdoUm5vN2h6YlcxVTY5WHkrb0pTMXlmSGVGYkZ3R0JlTE5ieW1SSkNsQ0pEM3JOZXE0QzhQQ1F1MWlkQXRYa1pDVzNwempYZ0R0VGgyd0Jsa0p6ajNTdXFkeCt5TU45c1V6T1B6Mno5WUswVU03TkpyWHJlbW9RPT08L2RzaWc6TW9kdWx1cz48ZHNpZzpFeHBvbmVudD5BUUFCPC9kc2lnOkV4cG9uZW50PjwvZHNpZzpSU0FLZXlWYWx1ZT48L2RzaWc6S2V5VmFsdWU+PC9kc2lnOktleUluZm8+PC9kc2lnOlNpZ25hdHVyZT48c2FtbHA6U3RhdHVzPjxzYW1scDpTdGF0dXNDb2RlIFZhbHVlPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6c3RhdHVzOlN1Y2Nlc3MiLz48L3NhbWxwOlN0YXR1cz48c2FtbDpFbmNyeXB0ZWRBc3NlcnRpb24+PHhlbmM6RW5jcnlwdGVkRGF0YSB4bWxuczp4ZW5jPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyMiIFR5cGU9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI0VsZW1lbnQiPjx4ZW5jOkVuY3J5cHRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNhZXMxMjgtY2JjIi8+PGRzOktleUluZm8geG1sbnM6ZHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPjx4ZW5jOkVuY3J5cHRlZEtleT48eGVuYzpFbmNyeXB0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjcnNhLW9hZXAtbWdmMXAiLz48eGVuYzpDaXBoZXJEYXRhPjx4ZW5jOkNpcGhlclZhbHVlPlU4SWVpL2VNS1RONmhLc213dWFxL3hKMnAyYkZJV1UxYjVKR2kyV0V0ZkFmeVZ2Y0k5ZGdlVjh0QktoeXllUGVCc2tFVmZUNnJOYnVnUzhrZGg3K0QyN1R1RDAvWExla0JSSUhncTNIWFJ0aGpwc2Z6ZVJ0d2FnaGRac3M3OWFEOSs4dUhLMzBxa3N0SWZCMDlMN3JxZE1WcUR2SUNPNENUVXhBTmUwNFRRN2NrZkM0K243THZoeFJGeWdIRzVYaXRVcnVybmVqeWtxY3RKQ1pmWm9Fc0ZjdUVDR1FEV3pXMHJrNGRwNXlaYVppR25CQjdjSVJDNXZOS1hxeGo5NnVlTzJ5YjgxMHFNK2JSTlhFTUMrdnZHMTMySitINTQ3RlR3MDdwZWowVUY4dGVGUG5aVjFVS3JaYjFkRUo4ckxqTWdHMzdMQmJLZ3Z1VXp1ckc5cy9ST3ViSjVkc0p0V29kMnlFT2toa2tuaVZLcTYydzVjdGlraTM5VEpjaXF3eDhqWlJkN2g3cURmSGdmU3dsZDhlSkdMNEt2Tmk2T2RXK2FteVluSU05ME1OaDlSMld5aklJcUNVNlpsaVA4UXIxeTRVS1FaSWVFU2ljdlcvT0JtV1hlVnh1c3lEcHgxMmdNMTNwSnlrTTQ0S2pCTWRqay80bTVJRTRRSE1hV0FESkRqYTVuRUxiK0NJZjJLeDg2VDBGWlhwWHQ3d1lQMUJPcnVPWWxjUThHbmh1OWNYZ24rbWx3NkZtZzNvMUVQRmxDZzRwaTduaC9zK1ZVM044c2pKOUc4SzFQaUtnZTBrK05sTE1ndElXRldIU0taTUJyMkFVRm1DOThzSTQ3NzJ1SVRuSm03OHFZbzM2SCtZSGVzL3pPQmVuTEs3ekI1ZkhjMlJENHMwT3pnPTwveGVuYzpDaXBoZXJWYWx1ZT48L3hlbmM6Q2lwaGVyRGF0YT48L3hlbmM6RW5jcnlwdGVkS2V5PjwvZHM6S2V5SW5mbz48eGVuYzpDaXBoZXJEYXRhPjx4ZW5jOkNpcGhlclZhbHVlPmd0YjNhMGk4OEpURUtyMTBtUlBKMGdxYmZ6UHBHNzVuTW01dm1pdlllTnh0dHpNMVpIN3Z3dHBEaGlaUmJYUGRCMjh6MngxZlVZTUVXTTNGYkpvTFJZRFJXY1p3K2lRVmN3bmI2dmdZYUJKUFdPUmNDNDlLZXBDMFR2RzNIUkhqejU4eXdhS0dSNTVtTTRBdEEyU3d3TUZoRVhxMzlYTHdnZGY1RkhaMEdoYVE1blE2KzU2K282U2E5ODdMK0x0V2ZzdFJKbElndzBqS0FTcjZkdHZMa01UNFdabGk3T1pBSUN4M3E2MVNGbEppZ1BoQ2VtVGduNjhnRmNzZHNuZjM0K2NwZWJ1ZUFGSG9ETkpqWkV2dFZWSVBKRzFNbktaNm80SFljQndsZmRZS0FLQU9xekZMMjZqTkp3b24rRUs2K2E2YkFMblFwR1VtcjVjVk1PelF3Tk1aaVBYRkVndVhLY2NJcjRUQ1JLb0VKZDNvWUVKa21ZeCtWRkFtTklyREg0VjZvZnJkL29kZDRXMjEvQXhkZVpVNGpxRDdxL3dacU1WYmlPOVQ2VFliNWU1emxvK1RwQ3U4NlhHR2hoSkZ1dzhYcjU1N05NZnk4OHdJR3hEV1VQZ1ZsNE1Zemd2YlQyMWpjWE5lLzM0YUZIV1UreHl2MVFTM2V2SHlPNEhCN2EvTG5teHZTTlg5MEtyc1dYMnU3ZWpSWXhXeUlWQXFlSnc5MFR1bkIyNzhWZGlhNk1jdkpwMXFqSEg5alJYeVVsUHoxclFMcGdHU3BzdytRc1FvZ0pYdnFsRk9RdzRuNTg5V2dvYjVTSFB1ZVQ1akFrYkFuZFJvQ0dBaENhTXhLQUlkemNBY2NCbk84N3Jlc3JjQm04U0pvVzRieVpPckdWUXVGbk5iS2dIdjlaZ001Uk1lSlNuaDlaOGo1UDlpLzZGRFdnYnZPMVZrbnBDeEdZSWlqbFRCQnBZa2FLUVhmSjQ0RzQxMTNmWUxZbm5oYXpjL1pFYmpJZVNsYU5xcXFER2I2WlFoNDJyd1VkeFlvY042UGVPa09GMC9ERVF4MGZRM0YwR1ZvNysxamVrUEhNenNYditaaXFCQ0ptRW5PMzlGOHZ5bmtvTjN5T2hoUFZwQ0JtUEhDZVEybnR2cTJFaDJsYWhiVHRRajNpY3ZyUGxiNUVDSkM1WTJ2NWZMbkhvbjcybVBaeE9NYkFkcUVwQ01NTi94ejBWQ1FoTzN3bnQ3OHl6UlUzbXRXbDVjS2hMTHgrNWJuSWtZM0YvMTR6dk00MEJGaXhWam55RmcrVmh3WFBUVVoyaEJUMW93WS9uNWl6RlBtKzVaaE9tK09ORVRjaU9kbFp1YjAvSnZnVFZ0a2xRU1FUM2FIbTlCc1VQTzZST0ZEMWVsaStZNmJLd0RlSW8xaDRsSnk2M0Uxd0N3bTV2a1pROFNqcEFtUjZnWit1NHVyZnN2NzYxS3FuZUVIRG80L2gyczMrUDUwWUJoMW9zbmRFWWs5NVE0cXBpbjRRcGNuMno3YmNNbkw2d01US1B5dnNBcE1ESzhZWmFPRUl6ZUtmTVNYL0Z6akgwamZtWDQ4dHQzRTRzQUFjMFBDNHhVNWNpYjUwNGJ2WkFBeVZia3JoOHJJeDkvcVU4NEx0RTlYMTZZdWpzRE1kcjJTVzdBUXJvNmlGTjFUeTB4QU5EYm5PMHNFT1lBMnhoem91UEVWaFRHSEdKRzVMUzdTblZ6bWNVOFJmYm5OMmoxTWlzT1pyRjNURmhpaSt4RUlmcWJHdHhuTmZXenhMRElKSVJFaktzRUJnVXZ5eHBzVDFYMkE4T0NZUUFWc3lNaDZJM0VIQm5jUDExMURjYUJKQXk5cG1uZUVGSStvbEZWSmFOREY2RUVpS1U5OVNWb0NZMGhaOUxESTFZRDhnbHZMWldxcytzM29PUDhQbDYvSDBDZGJ5dWF2MWZ4OFd5dnpkWXhaTjJ5TjdqbFkvK3kwTFFaa3NTU015Z2FsclNWdG4yREU3MWFYb0RscDdVdFpZMXFSa09OUlVKTHpIaGY3anlUOEFVMVRkYkUvczVnZ3pkUlp5UklteFdhS1NXbVk1b2ROajZiRHRLY1FEam9tYzJTYnpRZklXRnIvV3lrMmQ2bWN4aUNYMmY1VytoZlB6TmhkbTZwWlpRdTZMT1QyWHZBUU1SSGlxZjRhZlAwYXgxbCtKdEFER2dVNTVIWm9TK3lVdDdLaVNJdWRyN0RZOEJxSXgxeFVaSDB1TEVURE4wR050SExrYUtzQ2t4NFZ4TUVPQ2h4c1EzQXlPWEg0emY0Y0t2WnpJQi9KZGk0cE5tWFA4NGRGU1pFU0Y3ZVFWcW93WVl4MVFOZ3Q4Nktncm5FbDB0V3F5K2RtTXoxK1Iyb1J1bWhJbzhxN2pYSVhhUGhkcGdqcnl6MkgzcXdCUUZvUkNnUk1VQUhLQncxSHRWZ293MGtvR3N0Y1BtajlCUTgrc25VQ1k2R0IxV2ZKb0F6ZUJkUXNNeGl5OUY0MFAvdmJMUVozbEJKZnlGZjRoK0Y0NnV2V2s1UEw5Y1BrY0JTOWhHcmhMbjN4Y0ZraU9kd0s2djlDUkVwSjhBdnUyZjkrL1pPdmE0NldqTnBMSG9rSFdmL2NSd1k4NzZMOENmaEd1M0ZsSEplbU1uenZHejY1Z1IwTk4vMEd4ZENxcGlpNlJ5OGxjeGxrMXBSN0l3SEtNZUNzdDY1WHFlN1MwTFd4d1huZnkzeU4wTXgxdXkxeVowZzkzNGc2bCtFTXVOd1M0azMzVUhyYVVjSGZ3TjlMZlpRMitBNUpqdWFiRXFsbjllWGZDcVhyZ3JMKzNJNEFQM2JsYjh0bzIvNlExanhMeDdYVTlpTHZ1WXQ4NmpwMFRQVm9GQU1wSVRubUFwSWNUMHdhRFIybHFkSmFnZk84MTlQd2E5Nyt6ZE5Xa2FZMGN3QnZTcFUzYlplQWlIVE9rYlBldXRoUGNia2pMQS94UzJLOXlXbzdDRWo0dWh3SkwzWTljNTd1ZUtlaHYrSnhMVVpIajFwU0t6TVFENUZScHNaSWpyd3JSeEFOcXkxSjhlSVhyemdGUjBOSktPYllLUUxQdy9SeHEwbnFnaXdUT3ZMNzdLSUZPbHpsZ29LVFIzZkt1Q0lpLzl2ZFBnb2hMZC9NTHhxTDMwV1NOOGRIVUFGR0k0UHNKMEFGNmpDdi9jWmloK05SODRPcW53M2U3TktIV0dabi9VcWlSVFprejdBcUFoaldXaHA0THFqVVRkKzBUT3dSRXFSVnFJNGx0VTY1eWo3bExDZmlBancwaFlRRG5uYzhtdTA2Z3ovdG5UTDU2NnloSGI5NUU1TTRVOHNmWmZQeThnR2JMRVk2QnI3WkpqMzUxMEJuMlFBUEJEejkyU3d5a1MrbVdWOTdoNlQyUU9PMllWY3BGUmdsTkQzbWZhVis5SUpKOW1nQ25hVGJjWVdSVkFORFBkZXE4ZzY4YndDN2VyREp4bS9YdkNBeURJNjFsTGlUWU9qdzRmNFFrOXFaQWVKNHFDemxKMkJ6dHZtMmJ6OUtSOEpmQVdlV3ZwTFc1ME9UdFM5Y1NqWTFEVmxnZExEVVltR3B1ZVhXSU81VlBlWFBZWmM3VUU4U2U3NXVJVEFpVjlBOTRjbVREVisxWUxUSFVnWGtQUTBINTcrS3oxL0RXNmFHbzFvWkV1RjZzbHA5Qjl4Zm5lVm01SHJVV1NRSXA2bUt4Y0xDUWNBakoreFhkc05qTUVKR09yQ2J6MEdJOENVaHNLVmo1YlJ3ZnVLL2hMbFlPYnpTVjJGUi82RWdhWXNJbHR5RjdzWWFmM2JMd0ZQUVBaRjU5K0lsL2dIL1lZZVdQTlBCeUF2ZHFYNjZRYStkUktFenZhQSt1RFA0d0RkZDJtZzdRUXFRNmp6b1JLaWkzQXgrejBSMlJOVExzS1NFY2lrTnFFc3F6c0ZGT2NPUllLWGdzcEQwd1FjK0VvZlFZUWNOWGdHYjZLZFNnT09QK1p3NDlNSElydVJ3WEdMZVl1NjRQY0wzNXNManlMR25vT3FZc1ovb1ZBMVpPc2p4cElaNzdhUUw1UlhDZ3NJUE1vbHlsaW9EazAxV0l4a3FadjF6SFV5NzVPWHJVaFNJVzNudDVPejhwNEcweWlES3lSVUszWUgyQkN0bTk0dzM0UWV4bUpiK1AxdldtaExwdDk3MWE2RjVTd0NtaW5Tb1R4RXdSR0RoSzlKRGp6bTYyTGNZZUgxMkREQ1Jvc0JQRk90cm5FODlSRmZBYzZsU295SmVvVUtlaUMrWTVucWdQMHBWb1cybmRsM2JXR1hycUVzTDRJM3hzQmx6eXA3MlVZSXRrb3FSK0xUOFJlT1N4R1NWZDYvQXlCYm9JUS8zd1pBRWlvdm1zUndkeTZuNzFLclhKTU5UYWpwNDZ2SWtrNjN2Rmh2L05oUWJIVUVGczlKR1g4V2YrZ291QTMzbHpwVE5JTVoxQ0V0TVcxb0lXMEdTZSttVkhwM2JOOHdBajc2ZlFhZ0lTQVo1em83NEowcHNpZGJuQ2Q5OHFpZXRabTE5Tk9xdEJvTnpOZTQ5OHJSQ1Y1ODRpaGdOTkUxTUVZYVlHQ3ZDL2JVTjViMEdtZHViZm1XdEI4eDNLWVFWYmhkbW9Fb01CWjUzUTU4NS9HU0RlTTVrWEMvRWpZZ09QZTQ0ZXR2OFl4NGRGTW15bEpSTFVCakFndm9TRjFFTjRVaXZVOEwvNTc1TnI0Z0VnaU1PblpHNG5oNGtVaXM5YkJqZGNpalV0eUZiRUVjYWhGa09UT2JWd3RLejkrajFkSDRJRWQ5bGRwUTl6K3RPWlVNc000MktZd3pXS3Fpb3lNVmg2YWgyWkszU21JYVJBbklRdUdFMGMwUE4vL0M0U29VYlNucWNhVHVWc1E3R1krcy9FSGNPc0hTUlJ2UEJVN3NBb2Fiak5SM3lHMXEwUnhIV1A5d2VNZFJLblRrdUpPYkFnQTJSWmhqS0hZSWdRTUhoOEduczhSaTZzVGU3NW1WcndhcmNWLzZxQW1tN2J2K29ucmV1cXVIR3diTDdtUDErYjl2NnZ3VEJuZDMxNG11N01TNWwveEdSRWllMHJyZk8zVmxURGplSGQwNHJ2QnBWN2lVOUxmdHd6RGJQbGdVYTN3ZzVMU1dUTVNHZU0yN3RmY2tjMm0xVU1SYTAydFJnVTI0YUNHYnFReWw4Mkg4RndmdnNFWEpXdTJpdVU1SlcyQmlXSEhDaVYzRDNQWWF6eERLRmtKZjEzZW5ZYXZaWll5eWtDSXVkVzNRRVBZS25URnh1bnlOczI5eGlsakVqY3A0M1JyYTRQUkFSQVE5MzhKblhFUjMzRVJ6UGJHQlkrTVJJK0RtTFJZUUhzdU9zVFgzOUhEc25xN0t4RlN5eXJLbjhTZ3dSMG54NFhDWXMvV1hERWpLY1dKa3gzSzhQalpka0FiMnppelpBZ3FtandzQTJyZHVtYUszUDQ5VWYwd2QrcnZxZDgyYVU0akFCOTdHYVQ5cEtqQ3Y2cHlibUpaSTd1YzBNbFE3TnhVUHVXQWdxYlpOaklNY0w5a3UrNVhYOFlPeTVJclFYdlV5UjJFcFB6MG43R0l4bDZFQ3ZkZjFja3g1YUZ0VEN1Z2s2UE1hUU9uL2pjdzVHN093cm9aMGtpK08xKy96cm1FWkpnYTIzM211TXdsUDJOUS9NVmJoMGk0bWpKeGQ1RlAxeWZRYysyY3dFbVZrZ1lBYXZpald2cHQydktwSG1QYzdCZ2hZRXZHWG4rMHdkTVc0TFJNaG1nWWZnTkVuQWRnd1prQ1dRZ1BZbDd0RklnM2l5NUVtUUUvcCtrZEMwamJ5UmN6ZjIxRC8xTTRLeXhPS1NnajdVQ0JuWnBGb1NaLzNZRXJOb1FBK1IzUng2QkpLbXFxZzNWdEZiRWg1Z2xJaVhsaW5mV3g4ZnRWeG5oV1JQZHM2NGUwb2d3OHZPcXJvYUlCZkdkS0t5czQvLzF5TUdiNGJ2VE9WVURtWG03UU9WdWZCTTZ6aUdDM2lFaGhnVUZFQ2IwK0JrV1dsZjVqYU04c2syMDU2Ukt4RndmQW8xNFhBL1NkYUNDWFF1MUQxTkQ0bngvd05hZE1RK2RQc2xGNGFrc2d1VnZrVTljdmw4Wnp6WnRMNGtaMm1NQXBrN3JGT0tQOUlRSGJUL1ZJYXRRWEtTVituQkU3SmJkdnBlV24yS21seUgwU1VUZGl6ZWRxQmZnTm5XUENKUzFsOTltdDBJb0RrWWJ3M2YzREZpbTNjZ1p3UFdKMW0yTHFDb1ZpNU1iMXUrMFJFSldCTk1YS2diQ1pOd3hybGhtNCsvdUVhTnliRzZFNTB3ZmcycmZHMlg5eUpjL2lLOVhyQjNkY1I5VVBpZGlLMVZ4by9qM1p3b0YwdXFLWTBOVlRsNHRMY3FEdFc5b2JRbVhWN1dMR1BPaWVBZzNhcDJwc09SZVBYblBvVWtPZkNnVkhITnJ6eU1sbGNaM1VJcEwrMjNVZWp6dldyNmFEMjNNbnR5K0w0dFcxZUNnY2dkNEY1bDVCU2pYZndoVitUazQwWHc0WUpHZkVEcmhWSXJzbFNna0g5RnhJVG1hay9YY20vSFlSSENHaGJBa21pbVlBa2hPYmNHbCtrNFM5NUlwaTYwWlJxSEsvdnZsQll0WGZIVFhVWEpmV1dreFdDT3pmMkIwRVRWUjEwVkJLMjdPRGJLZnI3UjJhMTRvQnZXSzh1azFEMFF5UnpPQ2tpRzVmYk4yc2hSb1pKSS9vSE1SU01ueCtqUTF4WCtwdml6aVJxWTlUc05MZnk5K3lwNEJxa3g5UjdrNURpQVIxZDFNREhObi8rUHFDOVNOaG9JbnlPcnk1YTU2dkRsRjF4azFrbnhWcEZlbUlCdmFSYjVhUVlyZmx3VDBUWjgxd2NCdmJvY29VSi9EMEo0NnVwWmtVN0VFVmdqQ3UzZzNnQ1NjcWZPdElxaHZ6YVJNcCtHSEl1ZUM5SThEM1R6LzhtZVV2eC9WRTZHVDRpRUs0NUpSNXd0dzRvQ1FhaVZpK2s3RDFIZmQvbzlSVkd1ZkFnMklQc2UydmRGc0x3TFJOQmVnbkFEc2Y5cWlPbHZ1OVh3TVVpN3c3bzdLb3dIMHlJZUlYK2c5bEhCZ3kya0NwTEFRWk91T014VFVtZUZ5KzltSThwUnhpOXBmR2M1cWFNQ3RWUTIva0xCWWlwQ3dBQi83aS9MTldOcGlMamRkWHJ5OHlIeHY5NTFhSnJiTTh5QkQyOTV5eWVMWEVRTjFTbndYTXdqZE1zQVhCTmN6RVhvSEpzSHVHMEV4aTlWckRsaG50RjdSMTM2REZ3MVMrQWZ3RTBnZzhJT1JWckFNOWZBQ21jZVR1YTd3cy94aFVwSmluN3pKV2QrNnlBZHd5ek9Id3l5S0QwdjhMTVVHdlo3ZWpsODZIVi91Y2d4VytqUHc2Q2VIQmVhZXVPYXFrMHlqazhGdXpoZ3dTTVh4WitWMnA4bEx4aEhoUU9TS2N6T0J4Z3BJcjVGOEsyYyttSjYyWVc2SmovMnNES1BoT0paTDRaSXErVCtXOTVYNHdBWUk3Z1UyUDloWFo0TnhHZDgzN2d0SlR6cGp4SzJxT1ZRVm0zS0l3RTNIc1ZQOW9FN0F0OEJBcFdYbTFmTWx6ZUhoSGdMKzBkdC9tN3ZTM2dXZTE2ZWhUdDAvdURuZEE0aUJVcjBMaEJSdEdxbEN0dlVtc0dzelB5MW0rZGJUVFNPVnJCRGJoTUt2QVNEcE83dkVLeGxKOXhHU0lhckNRaEJoYmVpQXRxZUc0UGlUaXlTUTVEYVhSWUs1c0pmN2FhbTl5aFM4ejBoN0dJQ2RsWk4vL3YrTE0vci9vbkxEU2FGYUdmVjBGMXFJYmlucFVKY3pNWHMrVXRGTUo1ejBudDZGNUhxV1BEdVZvTVlSRElVenBSTDdCOWtVMVhtY0VCdHF4MjJ4VUZpYURtNGtKTll5YUVqUDVNRVdRbGR5Wll2OFdmbE5wY3I3WjBPV2o0K1NrYlFpSHViZXZpMmN2QkRrZExDN2ozNXdDcWtiY3VISFpzL0F5UUFXcFZGcFRPM0Z6U2RiTXBjZjIxaGVIOVpnbmNZaW8yaitlUG5QQlR3aVRIZmJnQTlLekhSbkR5QWZJZVV5Q2dyZEFQS1NoaWdVK1A3a2lqUTlIdFJPNVNpMjhnR2dveDZNa0FMY0hTa0d1QVVTVkZMNEgyRXZ1RGd3d2RuMGVzTjd6Y2N3d1g1MFBWRlI2VHd0eHZlSFI5WlpaY21ZOW1NV0M2OE9ISzBvcHdPWG1pbGpqR2s0R0ZaRG14MWlTclByR3drbDI5dzhlR04wU3pUTjZLS25MMUlOQ3FGNUJsQW40YktoNHlLeG5zajhrdkVTQm9LaW9NendZaGVuUmFONWZPSlM3OC84cmRMZGxPMHJReUo1NE91ZWxtRHQ2UDhWTlBDYzFpaGloMmgwZEtqaXNCK2VYSGwxbGptVVFZaHoraVhBRzFYV2VXVmVnTjRUcHlqM3BBdm1XdG9KOExWU1VnM1NHNHdRZDVlSi81K2NnWC9RVGIrTnlxVm1ycHc3V28wcW94NEVwYmJ3enNpakxMNzRvR1IyWXFCL2E1NzZBSVg3OVk4bDJRRExjR1RadUJtSEI4b2xIMVhEWFBXUGFtdjlEWU13eFRVRGs3T2Y4dXhWZEVuY2hwZklVdHkvQU9wZTV4S00xdG9zdVIrWnNSZndUK1UweVFKbUtIYzJsaEp6UVhVU2tDTmRYU1lzY2QxMWV3OW1KZ3Q5S2w2cWowWUdhS2xVcy93b0NBaU1pOXJvQ1oxdzFKQ1RPY2NsTlp1VXk0dmphd252QzZtSmV3a0JFSVB5ZTduYkZBSHloS3NFcHNiQkNPUmVNUjdhRTlDODlUSmxnK1d1Qm9xRktXb3orckVlVjV1S1NiQjRCT3BPdHJaSXMzMWtFNVd4VE1vbE1EdW1XR2ppUVlpOHUxUVdWZTJnYUt4L0JyVGk3aU1GZWphYXAyY0NDWFAzRGtPT21sbFdiRGQwc0NIbXF6eW9xVFQ3SmlhUXdzeDVBVy9CZ0hOeC9ValF1ckYrYXNCL0pOQUJxQytZV3RBakxNUFlVK1NEc3g4bXcrRlNBeHJTbElNWGk4NFNVSXNjd0VNRzRPVGxnWmVUOTJRaGpNeTFUVXdKTGQ5ZXVibnFFaytVNFJsUHV6bkNNNjlzVUE3OHNRM1VKSzVnZk10NFhmUzRnRExpdk5WV2J2T2U3QVdocmI4SDRVTGNLS2lNRnc0RXJaRGFWN3hmL2x4dDBpNVFOc09tTVZsNjFkbGtvSWQvSTNRTjVMRlJlbktoVlYyZ3JKWFhQNm1ETENSelJYSTZwTE1TTjNBVk4zbmwxT0xYQXFLRTBrcU1EeEtrQ1duN1N4Z2l3bkZ2eWxpZGVwUWs0TjJ0eGoyckpGY3dmekQvSW9nSkZZUHI0QmFLQkxjcktHR0FkZ0NEbk9CRStYTlJvcG8raXBqR2VTYitVcnFseWZZQmhpaWx0MHZXeXFEODB6akZyclY2ek9TWVE0WmxkZ2Uxc2RnL2JPR3JLL0hTUjNGZElscndJUjhySlVOUXBKKzNiS2cxZ29DaW9XOVVpdlVneDYzSFJBTXFMVGR4R0dCSFVKNDhmTnFSbjhWaDlIajRCT213VzVISFpHUTJBeGpSU2RId0JGZkRWZEJIU013aG9GVlhIQVhaWVdheXRtaGlERFMyK2lFOVhpYXRTVjNNemUzcm84d2dFaFV5Q1FjbDliR2Q4azdkdGJEMGhCVExVb0Rlb0lWTlRGWFc3SkpWVVZCTFRrdUEwY0Nvdkd1VXVvaFNqbkNIZXdnNzdRU0x3eTU4SVEyNnVIdjlzZEpsNlVKQzNVR0wvNlZuSnZUaGhFbmMrdkg3bmd6cGpOUVZ0aFowem9kSGlPSGZPaGNLZEZsQ1N0Um55OVkrbHVRVE1tTVg5K3FSeXdVamJpZUxVU1lNM2VQZ2NtdGF1UmdHWHZnaWJ6VGgrZHlCalUxZkxYK0tJdDR6eWVPQ2Q5THdBV2VUUjFEajdUUTV5Yy83a1NQd3cweFc5Mjg2eUVQanpoRzQ4dDljU1NZSmdvOVF6b2lRSGFWMmZoVHd6QzM3RnZUZERxa1NoVDNFRklibEpWUElwMUtWRUtxQyt5SHV6OHR0dUNaeDRhM2t5enpFellBOFBNZU0xMkpiWTU1Q1VveEJ0OGpiWVRzd3FGT29LaVliYmZPMTlQQ0JzcVV3Yk1oWlc5MXUycW9ib3dtRGJLRGxlYkNxNWNPUUs3dTJocDAxT2U4cmNTOXZpVG1sKzF2NHBEWlBBaG41akx4bUdXTENFallKQmtuN1lPbmJOUDM5cC9CUUVOL1dMSG9VWXREY2xkV1dueFliMFhjVHNQZmw3UHRGaWxHVkMzY3NKNEtiR2RyZ0JUZGtDQTVjS0tPdlkwU3NVd1NEcnNBWmYwR1Mrd2xEcU5Qd3hmeHVJemdHTVZBSkd0dDNIMCt3dXQ2M2VMclNxV3kzckg0SHA1dkpBREFNQ0Q3V0RydmI5WkZTeTJpVTRqQU03YVlOYUxrWFRaekhZNnFhS0pndXBaemJuV3h0THk5T01LWXgySzRUWjBMbzRUc3BTMzBSbzhrZnJlTFBJMCtRaXNMSUZ5Wkh1a0ZBY2NWRHE0SFZ4MHIzbTJBL0ltc05oblg3YW9rdmlHOTdCNktzVHZDR1pEcyt0NG5KMmRPOXpZc2FIYkh3Q3V4VytkakZ4aFplZnJ4QmcrTUhSU0FqSW5CbVlXNEVLY3ZET0VtclVrdXgwMGdrWTMxQzdtV1VvVitFQktKOWVOWld5QWlTZWxYZnhBbFdPNGZuMlJJazBYV3ByK3JiSVVkMmo0Smc3MjJCOFMwK1A2WnRIaU5qSi9SL1MyYnRnTWE3dFY3L3VzUWgwNHVZalRqWDRrRWtoL1ZTamJoN0xIWHFTMEZ6NDJiU0IyN3pEZDlkUkhvZjlVZzlRdzU2dFUwempBQ2h4dkQwaXAzc2tTZk1DblFVTUU5cDBCTUhrRFh1VjFwM1hiSmVHM0ovSE9LN2hZM04ycFAyT2RQTTZJOFg4MW5GdXB2UkhkVnBLN2luN3hBbkFXSTJJWThqbG9LRmo2K01qRHVtWmJMWFlTT0h6MVUyUzBRVG13MjJjenhKUUczc2tYU01Reis3SFVldCt6NDB5QUFkTWFNTWJzQk1LWUNyYWxzYUdQbSt6cy80ZE04NUU0OCt2Qlk3bzVkL2R5MCtJQ0hEMU14eHYzT0RYVTkxNSsxbFdGWFdWMEZldjE0ckkwclFQVUVoeG8vcDJtOStnK2F0OURTOGhpU3lmTWF1dlFYYk56bUd6NGM1SHgrYWxKVGtIY0JiSE1OU09HMEhUZXJXUjhjTUt2YlZDWGZjQXNqOFVzamlENW5qVk5jSy9zNVlSUm1lRzlyT2pXT0Z0ZElzWG1zQnN6SDlxSHR1cUFZKzhHaUdKYldpbWYyOTJSZDFRQnM3a0ZFV3dTMStmNC9WRGVrUENRNUpxclFnaXlFWGpnTWVnMjFXYnNMUGVENExSMlpZM29lMDhnd3E1c1ZhdjJSV2NyOXM3UE5sZnpwZ2luNWVxdjFkKzMzR0c1QU50TlBSNDJJRFdCVTFhaEZzek10eS9SbkMyRDhaajBXM0sxT3BFL3loclFzS20yeHdzNlZyWU9hR2xzZzdlREUzOTdxRkxrSnUxYTlVby9uQWZ3azBXcm9laHZVbnNaR0pXNlBqdHY4aWpYcWEzY2g1dnZCdWN0ZUVPMzdyMkE4YmRGRTl0K1kxVDJvcmNUYllCVGIrK1duZzFIWi9JL0tLUVNsZ3VKYVFvcDR4WnF3OXY1NWk2MEsyQ084Zz09PC94ZW5jOkNpcGhlclZhbHVlPjwveGVuYzpDaXBoZXJEYXRhPjwveGVuYzpFbmNyeXB0ZWREYXRhPjwvc2FtbDpFbmNyeXB0ZWRBc3NlcnRpb24+PC9zYW1scDpSZXNwb25zZT4=
BASE64AES

my $xml = decode_base64($base64);

my $decrypter = XML::Enc->new(
    {
        key                 => 't/sign-private.pem',
        no_xml_declaration  => 1
    }
);

like($decrypter->decrypt($xml), qr/68351fcad4f2/, "Successfully Decrypted AES");

$base64 = <<'BASE64DES';
PHNhbWxwOlJlc3BvbnNlIHhtbG5zOnNhbWw9InVybjpvYXNpczpuYW1lczp0
YzpTQU1MOjIuMDphc3NlcnRpb24iIHhtbG5zOnNhbWxwPSJ1cm46b2FzaXM6
bmFtZXM6dGM6U0FNTDoyLjA6cHJvdG9jb2wiIElEPSJwZng2OWRkYTgzZi1i
OTNlLTYzNDMtZGE1Ny1jYTFhNGNjNzJjMzIiIFZlcnNpb249IjIuMCIgSXNz
dWVJbnN0YW50PSIyMDIyLTAzLTE5VDAyOjUzOjE3WiIgSW5SZXNwb25zZVRv
PSJORVRTQU1MMl9kMzg0ZjkyMDA3NDZkMDA5ZmVjN2ZjMWE3ZjJmNjFhZiI+
PHNhbWw6SXNzdWVyPmh0dHBzOi8vYXBwLm9uZWxvZ2luLmNvbS9zYW1sL21l
dGFkYXRhLzM0YTM1MzcwLTgxM2QtNDQ4Ni04OTU4LWE1MGU5M2UxZjIzNTwv
c2FtbDpJc3N1ZXI+PGRzOlNpZ25hdHVyZSB4bWxuczpkcz0iaHR0cDovL3d3
dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PGRzOlNpZ25lZEluZm8+PGRz
OkNhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3
LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiLz48ZHM6U2lnbmF0dXJl
TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94
bWxkc2lnLW1vcmUjcnNhLXNoYTI1NiIvPjxkczpSZWZlcmVuY2UgVVJJPSIj
cGZ4NjlkZGE4M2YtYjkzZS02MzQzLWRhNTctY2ExYTRjYzcyYzMyIj48ZHM6
VHJhbnNmb3Jtcz48ZHM6VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3
dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUi
Lz48ZHM6VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcv
MjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+PC9kczpUcmFuc2Zvcm1zPjxkczpE
aWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAx
LzA0L3htbGVuYyNzaGEyNTYiLz48ZHM6RGlnZXN0VmFsdWU+djRlQmQyMjZJ
Q05iMHFXYVNiQUwwS0l5TmVMNGFFUVJFUjNIdHVva0JTST08L2RzOkRpZ2Vz
dFZhbHVlPjwvZHM6UmVmZXJlbmNlPjwvZHM6U2lnbmVkSW5mbz48ZHM6U2ln
bmF0dXJlVmFsdWU+cXVNOVJuOE94WWl5am5Hb1FVUkthUU0rTkdUd1lFUXRG
NzRNRmJMSjl0NmgydDdwd0FtV01EcTFraDhLcTJ3L2JreVZ2eEZYaEhBYUx4
dzQ1K0dSU3NjeEwzK3p4R2xHMGcvWDJpZnBxMEJBSXduM1VsQ3VEWEpOUlFH
L0QybkxsSHZqY1lJSkt3enJMNytYc29qcVhTdFF2bFF3Q2tpbDBPaCtWRUta
Nko2bzcrWEFkQmwzVW93ak53ZTRWQVJhV2hlN2oyOFB4YThnQ1UzdytTTmtO
RGRHK3NBNzZLQ2NXTGpVdGhBN3pMY1VBU2N6MDE4UVVCbVhYeUVWcHBVR1ZD
RmM1L1k2eTV3eVRKYmM3WUNrb3paVUZpL2R4SWJ0RlVnVEZtWk5SajU5SWVD
MHFrSm16MjJFK3VEUTg2SUJzT2hEMk5waXZvaWUzSW5wT1NjKy9VWFh3alpW
b05UclRaN29lS3ZlUm9VbHFTWlY2MmpESmIwOURHR2x0YXBDSkxycnVIZ0VS
cUc4RjBTUnlDVWcwWGRFdmZKK1RSVmUxOSs2bVhjMFd1VHBoSVdvNDNYNHhv
QjA3YnQ2aXJIM045dGZsazFmSnBFcURWRDdKVWFJdnZ2UHF4UEtMOTdDUGRU
NThDZE9KSVJIZm11TkVKZnVjb0JZc1prTDk0eWxqdzBGMTJOa0daU0wyeG5S
MGFRckcyL0Jvc0FkcDBQM3E4cnRiaUhxRjRvamJidmx6STAxcXZLY21RdXZ0
cHdQUTNZYnJYTHhGWkdXRXZYREtJRzJ1YmpvcXhQNE5tRW9VZUlOZG5xcEVZ
S0VDYURITFIzV3JYSCtvNnIvbWh5VXVtOUxPNmdXTWRqRG9HVDBDYSswRUxm
Q2ZWZGQvbnFmZVFrZFNMUEdkdVk9PC9kczpTaWduYXR1cmVWYWx1ZT48ZHM6
S2V5SW5mbz48ZHM6WDUwOURhdGE+PGRzOlg1MDlDZXJ0aWZpY2F0ZT5NSUlH
RnpDQ0EvK2dBd0lCQWdJVVJuK3IvbVY0RDhldHMvd2dldmhHeDBsYVljVXdE
UVlKS29aSWh2Y05BUUVOQlFBd1dERUxNQWtHQTFVRUJoTUNWVk14RURBT0Jn
TlZCQW9NQjFOc2VYSmhhVzR4RlRBVEJnTlZCQXNNREU5dVpVeHZaMmx1SUVs
a1VERWdNQjRHQTFVRUF3d1hUMjVsVEc5bmFXNGdRV05qYjNWdWRDQXhNRFV5
TmpNd0hoY05Nakl3TXpFeE1UUXdOak0wV2hjTk1qY3dNekV4TVRRd05qTTBX
akJZTVFzd0NRWURWUVFHRXdKVlV6RVFNQTRHQTFVRUNnd0hVMng1Y21GcGJq
RVZNQk1HQTFVRUN3d01UMjVsVEc5bmFXNGdTV1JRTVNBd0hnWURWUVFEREJk
UGJtVk1iMmRwYmlCQlkyTnZkVzUwSURFd05USTJNekNDQWlJd0RRWUpLb1pJ
aHZjTkFRRUJCUUFEZ2dJUEFEQ0NBZ29DZ2dJQkFNcjI1aVZ6L1l0VFZWNGhG
amdYdFdHc1RnYjV2ZjNuT1FyeVlrdjY0V0w5a3RNdmpYbkNiN2NiRENJU3VL
RzFCOUF0eVBWU2diVTNjWkdlMFJlckY4VzB6NVc3YlY2aHlBU0NURUhJam5k
RHdubGEraVJjRUs1M3ZQeDNoMmZDS2JoV3UzMFg0QmVyMi8rUkxmNDVFbkpj
aVY2Z0plZGc2NzlQUnRzdlU3aEcxR0JpWHFqQmRqaEpQdEVnYStPLy9BODVJ
VjRQaHNUWW9xSDlneFg3d2hzRzVRckdIdjBRajNGZnRsSlR1Q0hkTkJQa2Iz
a1ExR3IxWjhJeVY4TFpxbmlGdWhRNGJ5OFNaSlh1N0hXQ05kbmtPUmk3MTRm
a3VRdEpKSEl1V3BnOHArZGJVV2FGL2ZvMmdTNThRWlhoQnh2VTdOM0lselFw
eC9oWmlvSUJxajEydVRQNytlQ0g5OHppVE4zYTZobmlSNWtsenp1a21PaCt3
R3V6M3Q1OW56elVLb2tkVk1BWWZ3Rmk0OVJNQXlhWjRMblRHSVMxZVlwWGY5
dWpGci9OV3VQVWZIRk80WWpudE5JbEh0RG4wOVFLUWtlODk5Z1NIeXVUUER0
V2FpZ3g2Zjd3eHNsanlkclZvVXJPcFdNQWdGQ2RFUmNDZElFdU5hcVNhbnBv
WWV6eWNNTC8rS1RTUmg4S2dWVnlMNm9XK3JrbVczbU1pSDUwT3czK0g2bG1G
bndoUzQ3dnh4NC9IZ1RrWkhsM3M0cTN2emxwaVY1eURHUWVkWnF1SzdaRTNm
a3lyWTM0Y3VJVWZyQ0xPdVJBUkQ0K0dSYnh1MEF1N0x6N21kTXNtYlc4RG9S
R1kwSURPZHVJYnZKMGFRV2xnMnJKVmxmOW1GRTBYQ1RpbVN0SEFnTUJBQUdq
Z2Rnd2dkVXdEQVlEVlIwVEFRSC9CQUl3QURBZEJnTlZIUTRFRmdRVWFqQm83
THNkYkViSzUwTklhY0RLaXFQdldsTXdnWlVHQTFVZEl3U0JqVENCaW9BVWFq
Qm83THNkYkViSzUwTklhY0RLaXFQdldsT2hYS1JhTUZneEN6QUpCZ05WQkFZ
VEFsVlRNUkF3RGdZRFZRUUtEQWRUYkhseVlXbHVNUlV3RXdZRFZRUUxEQXhQ
Ym1WTWIyZHBiaUJKWkZBeElEQWVCZ05WQkFNTUYwOXVaVXh2WjJsdUlFRmpZ
MjkxYm5RZ01UQTFNall6Z2hSR2Y2ditaWGdQeDYyei9DQjYrRWJIU1ZwaHhU
QU9CZ05WSFE4QkFmOEVCQU1DQjRBd0RRWUpLb1pJaHZjTkFRRU5CUUFEZ2dJ
QkFESzh4bE5kT29yRGRudmxhcFJzNURmd0ZmMEk4SDNWOUVPVTJJS2w4Nzla
WWQ5NzQ3SzhEUGpJY25NSFFLN3FzZXJZUERibEp1K1lFeUhqZ251cmpwVHN0
ZTRqWFpLYU56aUtoVEtSOGFHMWZ3RzZJcmQxZktoZjBtUVJNN2dCSFRPZjJy
ZGoyNXZ0SGlER1pBNUhmK0xyV0p4WEQyMTFjdTN6UzdDOUNjUmhGUUpRNXBm
dGE0cElrdGl6bmhmWjFtcmtOM2dZMTVLeWMwcjBBZG95RVluQytVVXpxZGQv
c3lJdWpPZzZJdml1UGd4QWdNS2ZaNXRxZEdWNUMySGc5bFJZVFB4ZU53cVM5
K2pwL1lqUk8ya1lEWW44eW00WWR4TzlvVmgvekZYTUN2RWErQmRHWWpYZzFh
RWswNWt4WXVNb0lvSm5JTFJRWjg1WkxBVUUwclVhYmlxNFN2WDZYZXFHaU0r
bjJiOFcreENPN3NtVFRYZ2VaV0pLbWhhNVNLdVV1aXFSTkRvWktSRlhmemg5
SG94MjZIV3RyS2pSbDRqQkh2cmZHU0x0Sm8zcDgxZ2xtNU8raTNZT3FJUXVj
QnRJVXhqanQ5eCtwNlJMZE9BbGd3dUVjZERWdjU5YkNQWTJOL1dhMjVhQTNX
ZkxGN3U3RjJMMjRUSEt0V0tQd2pwSHkzWXBjYldac1ZUWUltMk9leUM5bUlx
U1lmYUhIbkRLNU8rNEhqck9OTHF4L1JGOWlkNytLc2w3YjgvdXdvOGVPd2VW
ZXo5bmxTUGd1cS9PaDdRLytpY0xBSUpxLzIweHlIKzE5dGVaRXhkSUwycklC
amcwdmNZbytvOWRDVGJRTkhJM2lPTHVsaHV4OEI5UDFzblh2dkdIVlA5R2Ez
REREM2taQ1JuZzwvZHM6WDUwOUNlcnRpZmljYXRlPjwvZHM6WDUwOURhdGE+
PC9kczpLZXlJbmZvPjwvZHM6U2lnbmF0dXJlPjxzYW1scDpTdGF0dXM+PHNh
bWxwOlN0YXR1c0NvZGUgVmFsdWU9InVybjpvYXNpczpuYW1lczp0YzpTQU1M
OjIuMDpzdGF0dXM6U3VjY2VzcyIvPjwvc2FtbHA6U3RhdHVzPjxzYW1sOkVu
Y3J5cHRlZEFzc2VydGlvbj48eGVuYzpFbmNyeXB0ZWREYXRhIHhtbG5zOnhl
bmM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jIyIgVHlwZT0i
aHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjRWxlbWVudCI+PHhl
bmM6RW5jcnlwdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMu
b3JnLzIwMDEvMDQveG1sZW5jI3RyaXBsZWRlcy1jYmMiLz48ZHM6S2V5SW5m
byB4bWxuczpkcz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2ln
IyI+PHhlbmM6RW5jcnlwdGVkS2V5Pjx4ZW5jOkVuY3J5cHRpb25NZXRob2Qg
QWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNy
c2EtMV81Ii8+PHhlbmM6Q2lwaGVyRGF0YT48eGVuYzpDaXBoZXJWYWx1ZT5G
djY5R1NseWtZOVNLdmV5UndxMEZZbk92blJ2TlprTG1aU1NUd29KT1Z3c3BZ
dFZNRXVsSDk0MnIxT1h4MC9vCitxdFZuWVZvTEswMEtUYjdhMFhrbHVqSWVp
aFBRWFRiNkVvRFdwU1Z0SXVDcVA1YWxoZkQ2MVNHSmtQZUkrZE8KZjJWZ0V4
NWJyK1kvZk9jWXV1UjJzZ0kzVjUxKzR0SlNydm0zU3gzWHhUbTJVYXcrcFFj
VWZjTGRKaEFLeCtnYwo1TEtHNGNLeFNUUUlZOVgyMDFqMlhNYXQvMFdGQ3hq
bTFvT3NXN21RenBNTmZBaGhXMWl0OEJsYWsrMTdTR0dkCms2QTMxVUxoK2o3
dmM1TUk4bDJCRHBBNFlFdGpVTld5OSswcERrT2Znb0pMRE5DT29mVGQvdEFh
azd0TnBYSUcKVFBuQms0VzA3cXh5SCsrMlh0Q0xhN3ZHYTBQUERrcU1oWThS
aTQrSlBjTm00ZlY0c0NsZXdpMXptSVlUcU9lVApIbDhBNmIrNjg4LzFOR3RJ
czU0dU9mcWF1b0hYb2Nua2paVHR6QjVnc2o0dkJMdE5yb2xaUHRuT3diRWYv
d2YyCkx4UXJOT0pnMzJIQVpSaGJIeE9MY2RzMnI1bmtGRm9sVUxzQklaRXNH
bThSYWx2eTk4czVzblowektYVi9EcTMKLzhhN3FFbTArZVVGK3JVSzVDRUNF
MFpzWjdJTzFqOUlqZE9DbGozb3I2KzRnSDYwOXNvaWVHdjh4a2FYbGR3Qgo3
NFErU20yS1EwLzl0RkF5ZGFVbjJ0OEQwZzBDdnBHaVN0U285V3ZPK0NQVWYz
aE9OMzdJWUZ3S2hKTHg0SzhQCkt5UzNoQWRtcUNxeEdXY0txUGg4UldpNHZv
cXZzTmV1bnJHcEtlZ3FXR1E9PC94ZW5jOkNpcGhlclZhbHVlPjwveGVuYzpD
aXBoZXJEYXRhPjwveGVuYzpFbmNyeXB0ZWRLZXk+PC9kczpLZXlJbmZvPjx4
ZW5jOkNpcGhlckRhdGE+PHhlbmM6Q2lwaGVyVmFsdWU+VjZtb2VodURRTzdn
dHptd25yd0UxbHRiOUEvU3FFYmNWcW41Y2ZvSkxSWDI1QTBlNXZqcXBzdlg1
WXRISzlvSwpHUTF5MU45OGVQZ2hSWXhjdldONXVqYXNScFFTLzZYVFNaZHJZ
SlVHcWVOa3FzQzV6T0VaalNOUTdLOGs1MWRBCk5uOE8yd0tXc3F3bDdIRHEz
T2liZ2VvL1JXOHM3K0ZVVEpqR1RFMHpCZzZHUFlOYkNqZFYyWndxc1BQSjJZ
eE0KRGJsVitER3UzQXcvVHZNVnIrbWkzUDRlR2loNmdxMmFGUklOSWRqanNR
MERwWnVsVVR3Qk1QcDNxRmJ2bWcwbwpiYnppV0RsVHpzUnVWZkRGWXJkakFN
S0xHdDdWSTVvekExN3ZYRVVPTm56WlJSVHJyT1lDc3ZyVjJRamVPTHZUCjkz
QVdCWUsvdnFNWmlsVVFtL2hDRnZtNGd5RUMwMlFwN2pxdllTMmowN3QyeFF2
SHNxK2RGRkhBeHA2cWNqY3MKdCtVUlltL2taaVdsdnNwVlJFeUx2U1FTOWxq
NUlZL2VLTnZwRWpMNitzemhPdHF5V0JWOVpTSkxxTklKRldHSwpKQ3lLQnZR
YllWc1hHcHg0djFPYmxobzNSeU02a2hKWWdoRm9TamhCMmZmOVdGeVYwN3h2
RTIxVDQ0SWxwZUFnCkg1aWJwWm5jY2RzdGJDeHVsczAybVZjdGxjSk9JWTdQ
WklLbWtKL0NOQmxxV01aem55eUVYejJJVlljeUpvQ08KM2FYT1p2TnVXSWww
cDlFd2RxbDBWTXZlNmt0TWlkNUJRVkwzSFZUVTBVcVhuTFVnWHJTUi9semFw
UW9IT0FLMQo3dEcrZDEzRGpCYWowZDZ0NnBQSjlhUExMajFTd0V3NXpVengz
TmhIc0ZabmFNSWpKYzFjVXJkQlIvRmxGdlJrCk1raGRlU05KZVJ4VVJFVG80
dTNDWTNYbktCWTNTQldpRnZ3bkJSNFJ6bk9nQnpYQndGYnhMYnZpdTJVQW56
aFUKT2l0MGJEZjQyMXJid1p2OGFnVGdEM1A3Y0hmZ3NMTHUxcHBCRmtnMHhq
TDZkK2xSNllEZDB1MDQ0bTlXUlZ2NApKTnU1ZlhaaDdBTXo4eEttTEpWbFE4
WW4vVExPT1VJYTZ0QmYxRVorRDNtZ0xGMXArUWl1SjRrWVA2ZlVSMFlOCkRl
SkJpMnpxRUZxbGl1MTBTSHMrNW9mL3UzNXAvVGFTL2NCVU1ZbEhrU2JtMzc0
alg3Ym5POFJiR0JMeldHWXYKbXpqVjRxdmd1b2FRaE9LODExUWtJZ216Qit4
NmRlckNUbTJGSlkxc3lqdzVpcjNQaDdnVEkxWUNabktXY1JZZgpmY2hYZVBp
N2tkRmlXU3FTK2NWZ2tTeUh6MTZZZS9Fa3ZKQ0txQUNZcWRmRHJiWDg0TzRi
Y0xwRzQrVkRMeVZxCmFncWNTVXo1bFhhKzhUeVZNNGcwRkNkeVRtNUYwbGlj
T2s5TlZVazY3cVpxeTlkYTNlZUpRSU50cWJPVFJQV3IKY1NBVDd0dm52ZlBa
T2p6UjByZEplWFJHTkNkcWREUjdnR0lnTTE5WmJsZGt0anRCSTFLVlUya21x
dFo1dFZZUQpoREQ1dGthTDlTR3FFU3F3V2R2WDN4bTl5V0RnRlAxYy9qZWtI
WWNiY2R4Q0VheVBHYmE4VEZ4by9lcDZFWGcxCmpjNXRpby9BeEViOWlRQmRY
VG43dW1FYnluSkcwaUI5U2ZSRERVVmVKQ3FWYlZIaWZFWHJHdjE0RmllLzhh
ZnUKVkkwMHVSKzVHaUNCVFZHQ2NhbGZSSU90QjR4MG5kYW9FQXFxRkxnbUVK
RHFlYnJTSitvRXJ2Z09tNktNb094SApORXM3QStMZWFBTEw1S3RaWjdBTDVN
cEJrWEhidGNLb0pHdlF3aG1lVGhZNjd1T2VUUU0zbWtrSzNrRFBHRGJECmpK
L2ptcndNbnpuci9aeGQ1RXgzQUEvMzZVdlRpRDFqRGVyT01rS3o0OGVndTdY
eFNmOVd3Tzh5ZXlxdjJiaHAKbk96aktMMmovbUpqYWFtaFZ6WXdsbEZmTlRP
Q0VLVmZqNnQ0S3F0SkMrZ0hibkk5clB2aXpGOEQ0SENxT2NRWQpyMGE3bUVK
TGpoektSZS9OSUxKOWUxN0NxOFNrSklNdVA4Z1puem1TaXJJMVR2bWNvK3dm
Z0hzMkQrUUlkU0MzCjVVSmdKYU1acDVtUHJCb2F4YlJ6cnVPemh6T0ZycHlw
dHJ4MWl2S2gzK3NXeVhGS3dvWjN3T1dUV1AzV0Z2YUoKd1RqWmdHeVBYS21h
cGVoZk9kMmxhMlkrTkNZZ01XSUtNYnNoTTlKSlVqUUZ4VWIzVE93eEJycU9r
eWo0b1pubAppTHdqYSt3R3lGeXlEdG1NWUJEcUlWcTZ5K2xKWWg5WUkwQUxK
YUtnYmpjTEVQNWJ5eEJNNml3WjFpZXZ3NUczCkV3SElsSVpiYnlHL0lMbFpP
dXpEZTFmZW9vU1dDV0RPZ2NFak9lb0NvNkJ6QXJTK3h2NnM4aXVDTG5sUERB
QzcKZE5GVHlPazZYSjJEV3Q2MVo1Vm1XRjI0d29oMUtTblpRbHFwZUxCVmNj
VlZ4TWJBTk5oSGcvRVBJdVVmMGJqeQpGaDZ0SkxEYnZjRU1jaStvN3FFakN2
amphT3lLQ2IyOXhSQUlCdjZDNGwxUzhZOWZLZWs4dzh5Vlc5M0RDQnhQCktp
blZiditQR1RNbWY1QzV4MXcrRG5NYVhTQzV0SU01cjJmZndqb1hhUVJ0Uytt
VzJCMlNGaThUZldLSVRwUVEKdUR5NE53bUQrTTdidUFzb3g2RkRMVi8zYnk1
dUJreXdWRnhlZzdyL1ZjS2VQWTA1VWFTZ0QyOVBTUnhrd2pRaApIRkMzNCtq
eG4zK0NrblBnVGRDRzJ1bFVZK01zOFB2WjNKRXRsUmRHTjI4WWZnckQwRTVN
RmhQZXQ0WWYzYVNZCk9qV1lRZ2JDR25kSzYya21mUEFmU2wxTXNXMEZnU3hQ
eWFpd1pwUXkzTm9qem9hYUwwNVIwaUlDYXByOVV5K0IKcHBCNzBZeGgvclpQ
VjBkZDdya0FJTVdleVM4MjVOV2xFWmVOSnp0aGlRU094dE02YVVPN0xQQmU2
bnhjV2xGUgorM1ViQ1E3MFpDUzBtRStvdG5sZURLNkRqeHZ5MUE3UmROS3o0
YkZ2RExxcGNQUDlpOE5pQ3BWRThuWG1zdlVlCmpQS05BQkhoVWVxVWFlUGZz
QWNoZU91OFFGQ2lna3g1K0xMZngrZXM3aHBXWHZFUTlsYjR3ZkJ3Y3hOcWhW
aGIKYU92VVBxaHB4Z3FHUSttZVpTSjZsbWlPNTN3Wmk4WFp1MDVlNlFKNEls
aWpMSUsrdVAwZmdld20yWm5EY1d3VQprODVQMlF0MzJ6L3FpbHZ2M2poYjEy
c1IzZ3pTd1FsT0RZVDJXU0IwS3lBcTlZWmVhTWlLbEt1V2hVVkhEeWk0CjVx
U2dpOENWYXUzdURzZExTWmhVOFlqWkNQUWVQRkN2VGxEOWVWVndyanlhL3FI
WUFCWUZUckU1UTBqeTdjeSsKSTEyTFNUVHZ2VDNhSlc4S0hEb2RVQWRZUlAr
S2RNelMrNmVvNk1aVGk5Yjh6MjdNcVdkYStMaFJTd24vRmRERgpwYjk0bHZG
cmZSMko4V2lrSmpDSHExcEJiTkNVVXJZMDBwT2FjRTlkc1ZpMnB6a3NVblRx
TEdzM1oxVlJockxsCmlLQ2JFLzFUR0FVZFVQQjI5eHdnL2FmMFIvNFlwQTJz
dDJNTTd0THdjYXAzekNTazdwNTQ0eXVVaTAzL2ZKVFQKM1g4NTJ5UGRQK29F
bkpFcjlSZ1dodCs4enEwTkY5aFZHbFRkVjhJTHkyekIzVVlYK0NwNmhUTXk3
RWhEWWxadQpEZlhNVGhMekRsZ2NWM2ViSGxvWXVDaW9JelNieCtZaHhVVDk1
OEFxU0o4RXlSbnhDK3hLK0hqZU5hbXcwWWE4CkNmNHpQWk5TTGFGK3krL0hk
N0JTR0xxSURmeTVSSXpIaG5iRnZtMlU3TW0rSWpaUTdEcUJTbFY2U25VeCtT
R2YKZHZ2Y2NlYjhOTFUzQnRXa2VZME93dW9JdnE1UG4xWDRSMUdHRE1GeEd3
WDlBKzJvVTZ6eGl1Zzh3L1BJWlUwSgpwQmlZQWU3UzhKWT08L3hlbmM6Q2lw
aGVyVmFsdWU+PC94ZW5jOkNpcGhlckRhdGE+PC94ZW5jOkVuY3J5cHRlZERh
dGE+PC9zYW1sOkVuY3J5cHRlZEFzc2VydGlvbj48L3NhbWxwOlJlc3BvbnNl
PgoK
BASE64DES

$xml = decode_base64($base64);

$decrypter = XML::Enc->new(
    {
        key                 => 't/sign-private.pem',
        no_xml_declaration  => 1
    }
);

like($decrypter->decrypt($xml), qr/5e08ab4870dfd2f2a/, "Successfully Decrypted DES");


$base64 = <<'FIRSTGO';
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHhlbmM6RW5jcnlwdGVkRGF0
YSB4bWxuczp4ZW5jPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyMiIFR5cGU9Imh0
dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI0VsZW1lbnQiPjx4ZW5jOkVuY3J5cHRpb25N
ZXRob2QgeG1sbnM6eGVuYz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjIiBBbGdv
cml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3RyaXBsZWRlcy1jYmMiLz48
ZHNpZzpLZXlJbmZvIHhtbG5zOmRzaWc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNp
ZyMiPjx4ZW5jOkVuY3J5cHRlZEtleSB4bWxuczp4ZW5jPSJodHRwOi8vd3d3LnczLm9yZy8yMDAx
LzA0L3htbGVuYyMiPjx4ZW5jOkVuY3J5cHRpb25NZXRob2QgeG1sbnM6eGVuYz0iaHR0cDovL3d3
dy53My5vcmcvMjAwMS8wNC94bWxlbmMjIiBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIw
MDEvMDQveG1sZW5jI3JzYS0xXzUiLz48ZHNpZzpLZXlJbmZvIHhtbG5zOmRzaWc9Imh0dHA6Ly93
d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPjxkc2lnOktleU5hbWUgeG1sbnM6ZHNpZz0iaHR0
cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyIvPjwvZHNpZzpLZXlJbmZvPjx4ZW5jOkNp
cGhlckRhdGEgeG1sbnM6eGVuYz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjIj48
eGVuYzpDaXBoZXJWYWx1ZSB4bWxuczp4ZW5jPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3ht
bGVuYyMiPkthOG9IL3ZFYnZoTWRaNU9UTjRzTTRTdFhnRnlGcjF5NkkvOERUNVhRYXVDcVNoUlVH
TTAyb25WWWlYS3liUFdSdFhrZXlNeGE0NDkKWGQ4U1djM25hNy8zNkRoek1lWGUyRkV3REdGUk01
MUlBMTNuUHozcFpadnIzMVRGMmxSSmg4clFnU3Z1YkZKRUszSldIOE5kL0FZcgpCS1RmYXJ0ZUky
T0p1ZEJvVXdpOEN5QmpjeEs3RStWN3Bib0crSFRzWkZPQjdVM29vZE8ra2JTYXVxTjJucldIenMy
VzRsVU1Od1cvCkFySnZGT0drOGNiTVB0R0hnb1IvNER5QVFCRUovem5vc1BiYjNPdTZCYXhKVW5p
UVR0U3FUOXZLeGpUTFJ3cG1ZTGFGamdWUk0yU2YKbncxT1Y1YjdWUisxMjFZU1dNM3NUaVpzSkth
ck1DREw4eDhLZDUxdUU0R2ZncUVpbFBHSVFCZUZ5N3ZtWjdYa05FVFo0dWx2MzByZgpmdHhDTE9Q
dlpIYkxDd1RnaUEwamU4UW5sUWRvakFTN0lYUkc2TUptUTBnWXFnZVlBelA2N0ExN3ZQeTdZQXZh
d3RwMThXWjhGMHdFCkZoQUg1SWwySUpDUGtKUlNVVUFZSnlkekJac1B5THN1ZjN5Rk5ESnpoV2kx
ZWZLL0c0RmlIY2RoSDRwbERwSDJmRDN1THp3bk8xYmkKeVAwVCtzc25STDZUeTBuMXc2V2RtbUFr
OFZxTlo5TmtXYnAwUlFITHY2bkx4WHkwZVdHcVJRaW9xLzVzTkVnYlhLbGxaU2lWeDhLQgpCb20y
Z1BnWnozNGlJTEtsS2tCWWN3NTFSODlIVDNYSW5adWxPanpQeU5OMk92RC83K29SbHBYbEM0b1Iv
U1Jya3RyWDdtRE56cWs9CjwveGVuYzpDaXBoZXJWYWx1ZT48L3hlbmM6Q2lwaGVyRGF0YT48L3hl
bmM6RW5jcnlwdGVkS2V5PjwvZHNpZzpLZXlJbmZvPjx4ZW5jOkNpcGhlckRhdGEgeG1sbnM6eGVu
Yz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjIj48eGVuYzpDaXBoZXJWYWx1ZSB4
bWxuczp4ZW5jPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyMiPkZJVTZnbkQzWERG
K0xUbjhWSnJVYWVRNk1HYjN6YnJ5Tmxaa3hkL3ZZY0Z4aXQ0b1p6dGVHUXpqbmFlcTEyZG5oMEVC
cWJsUWQrdHIKb1VBM1VGRTZ0THZHYVJVRTlnVmVpMUFPdm5QYVI1cz0KPC94ZW5jOkNpcGhlclZh
bHVlPjwveGVuYzpDaXBoZXJEYXRhPjwveGVuYzpFbmNyeXB0ZWREYXRhPgo=
FIRSTGO

$xml = decode_base64($base64);

$decrypter = XML::Enc->new(
    {
        key                 => 't/sign-private.pem',
        no_xml_declaration  => 1
    }
);

like($decrypter->decrypt($xml), qr/XML-SIG_1/, "Successfully Decrypted DES");

done_testing;
