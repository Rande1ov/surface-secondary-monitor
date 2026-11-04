# Surface Pro 4를 보조 모니터로 활용하기 (Sunshine + Moonlight)

메인 PC의 화면을 단순 복제(미러링)하지 않고, **독립된 3:2 비율(1920 × 1280) 확장 보조 모니터**로 서피스 프로 4를 무선 활용할 수 있도록 구성하는 프로젝트 가이드입니다.

---

## 📌 주요 특징 및 적용 기술

1. **완전한 3:2 비율 확장 화면**:
   - 가상 디스플레이 드라이버(VDD)를 통해 1920 × 1280 (3:2) 해상도를 생성하여 서피스 화면에 좌우 레터박스(검은 여백) 없이 꽉 찬 화면을 제공합니다.
2. **2.4GHz Wi-Fi 맞춤 최적화**:
   - 2.4GHz 무선 대역의 간섭과 지터를 감안하여 **10~15 Mbps 비트레이트 + HEVC(H.265)** 하드웨어 디코딩을 권장합니다. 끊김 없이 선명한 가독성을 유지합니다.
3. **터치 입력 차단 (Pure Display Mode)**:
   - 서피스를 만지거나 위치를 바꿀 때 메인 PC의 마우스 커서가 튀는 현상을 방지합니다.
4. **연결 세션 자동화 (Ghost Display 방지)**:
   - Moonlight 스트리밍을 시작할 때만 가상 모니터가 켜지고, 세션을 종료하면 가상 모니터가 자동으로 꺼집니다. (창이나 마우스 커서가 사라지는 현상 원천 방지)

---

## 🚀 빠른 시작 가이드 (Step by Step)

### 1단계: 메인 PC 필수 프로그램 설치
PowerShell(관리자 권한)에서 다음 명령어로 설치할 수 있습니다:

```powershell
# 가상 디스플레이 드라이버 (VDD) 설치
winget install VirtualDrivers.Virtual-Display-Driver --accept-package-agreements --accept-source-agreements

# Sunshine 스트리밍 서버 설치
winget install LizardByte.Sunshine --accept-package-agreements --accept-source-agreements
```

### 2단계: 가상 모니터 해상도 (1920 × 1280) 적용
1. `C:\IddSampleDriver\` 또는 `C:\Program Files\Virtual Display Driver\` 설치 폴더로 이동합니다.
2. 본 프로젝트의 [`config/options.txt`](config/options.txt) 또는 [`config/vdd.xml`](config/vdd.xml) 파일을 해당 폴더에 복사(덮어쓰기)합니다.
3. 메인 PC `설정 -> 시스템 -> 디스플레이`에서 새 가상 모니터가 감지되면 해상도를 **1920 × 1280**, 디스플레이 모드를 **바탕 화면을 이 디스플레이로 확장**으로 지정합니다.

### 3단계: Sunshine 호스트 설정
1. 웹 브라우저에서 `https://localhost:47990` 접속 (처음 접속 시 계정/비밀번호 생성)
2. **Configuration -> Audio/Video** 탭:
   - `Output Name`: 가상 모니터 식별자 입력 (기본값: `\\.\DISPLAY2`)
3. **Applications** 탭:
   - `Add New` 버튼 클릭
   - Application Name: `Surface Pro 4 보조모니터`
   - **Command Prep** (가상 모니터 자동 켜기/끄기):
     - **Do Command**:
       ```powershell
       powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\guswn\.gemini\antigravity\scratch\surface-secondary-monitor\scripts\start_virtual_display.ps1"
       ```
     - **Undo Command**:
       ```powershell
       powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\guswn\.gemini\antigravity\scratch\surface-secondary-monitor\scripts\stop_virtual_display.ps1"
       ```
     - **Elevated (관리자 권한)**: 체크(True)
   - 하단 `Save` 클릭

### 4단계: Surface Pro 4 (Moonlight 클라이언트) 설정
서피스 프로 4에 [Moonlight Windows 클라이언트](https://moonlight-stream.org/)를 설치한 뒤 다음 옵션을 설정합니다:

| 설정 항목 | 권장 설정값 | 이유 |
| :--- | :--- | :--- |
| **Resolution** | `1920 × 1280` (Custom) | 서피스 3:2 비율 1:1 매칭 |
| **Frame Rate** | `60 FPS` | 자연스러운 마우스 및 영상 움직임 |
| **Bitrate** | `10 ~ 15 Mbps` | 2.4GHz 무선 환경에서 패킷 손실 방지 |
| **Video Codec** | `HEVC (H.265) 강제` | 서피스 6세대 인텔 내장 GPU 하드웨어 가속 활용 |
| **Touchscreen Mode** | `Trackpad mode` 또는 터치 미전송 | 터치 입력 차단 요구사항 적용 |

---

## 🛠️ 수동 테스트 및 검증 명령어

### 가상 모니터 장치 수동 켜기
```powershell
powershell -ExecutionPolicy Bypass -File ".\scripts\start_virtual_display.ps1"
```

### 가상 모니터 장치 수동 끄기
```powershell
powershell -ExecutionPolicy Bypass -File ".\scripts\stop_virtual_display.ps1"
```

---

## 📁 디렉터리 구조
```
surface-secondary-monitor/
├── README.md                          # 전체 설정 및 사용 안내서
├── config/
│   ├── options.txt                    # VDD 3:2 해상도 설정 파일 (텍스트 포맷)
│   ├── vdd.xml                        # VDD 3:2 해상도 설정 파일 (XML 포맷)
│   └── sunshine_profile.json          # Sunshine 앱 프로필 템플릿
└── scripts/
    ├── start_virtual_display.ps1      # 스트리밍 시작 시 모니터 켜기 스크립트
    └── stop_virtual_display.ps1       # 스트리밍 종료 시 모니터 끄기 스크립트
```
