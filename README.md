# 한끼잇고(오늘 뭐먹지)

**문제**: 늘 먹던거 말고 새로운건 먹고싶고 영양가있는 음식이 뭐가 있을까 고민만하다 결국 똑같은 요리를 하게됩니다

**목표**: 오늘 무엇을 먹을지 메뉴 결정을 돕는 어플만들기!!

**데이터**: 식품의약품안전처 조리식품의 레시피 DB (https://openapi.foodsafetykorea.go.kr)

**프레임워크**: Flutter
<br/>
<br/>

## 플레이스토어
https://play.google.com/store/apps/details?id=com.kangsudal.whateatgo
<br/>

## 어플 사용방법/구현 영상
https://blog.naver.com/kangsudal-dev/222982435173
</br>

### 기능과 사용 라이브러리


**기능**: 랜덤 메뉴 추천, 레시피 공유하기, 북마크 기능, 자주먹는 top3 빈도수 체크, 식당 찾아주기 기능

**사용 라이브러리**: `http`, `flutter_riverpod`, `hive`, `shake`, `intl`, `share_files_and_screenshot_widgets_plus`, `cached_network_image`, `google_maps_flutter`, `geolocator`, `flutter_dotenv`, `url_launcher`, `rive`

`http`: 조리식품의 레시피 DB에서 json 데이터를 받아옴, Google Text Search API에서 json 데이터를 받아옴

`flutter_riverpod`: shakeDetector가 동작하면 새로 랜덤 Recipe객체 계산해 상태 공유. HomeScreen의 Consumer에 전달된다

`hive`: 단말기에 데이터저장

`shake`: 흔드는 동작 인식

`intl`: DateTimeFormat

`share_files_and_screenshot_widgets_plus`: 레시피 화면 캡처하여 공유하기

`cached_network_image`: 이미지 캐싱

`google_maps_flutter`: 구글맵 사용하기

`geolocator`: 현위치와 위치 권한설정

`flutter_dotenv`: apikey를 숨깁니다

`url_launcer`: 식당찾기 기능> 구글맵에서 마커 선택시 웹브라우저로 연결

`rive`: 로딩 애니메이션에 사용
<br/>
<br/>

### 코드 실행방법
1. https://console.cloud.google.com/google/maps-apis/overview 에서 생성한 api key가 필요합니다.

2. 프로젝트 루트에 .env 파일을 생성합니다. 파일에 `googleMapsAPIKey=구글맵apikey`를 입력합니다.


3. 프로젝트/android/local.properites파일에 `google.maps.apiKey=구글맵apikey`를 입력합니다.

4. 프로젝트/android/app/build.gradle 파일에
```
/* 디버그 모드일때 주석쳐아하는부분 */
//    signingConfigs {
//        release {
//            keyAlias keystoreProperties['keyAlias']
//            keyPassword keystoreProperties['keyPassword']
//            storeFile file(keystoreProperties['storeFile'])
//            storePassword keystoreProperties['storePassword']
//        }
//    }
//    buildTypes {
//        release {
//            signingConfig signingConfigs.release
//
//            minifyEnabled true
//            useProguard true
//
//            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
//        }
//    }

/*    디버그 모드일때 주석쳐아하는부분 */
```
디버그모드로 실행시켜야 하므로 위와같이 주석을 쳐줍니다.

5. 실행~

### 프로젝트 구조
