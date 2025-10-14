# SafeView Production - Docker Orchestration
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FSafeView%2FProduction.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FSafeView%2FProduction?ref=badge_shield)


이 레포는 3개의 서비스(backend, camera-ai, frontend)와 MySQL DB를 docker-compose로 한 번에 실행하도록 구성되어 있습니다.

## 구성 개요
- backend: Spring Boot (8080)
- camera-ai: FastAPI (8000)
- frontend: React(Vite) 정적 빌드 → Nginx 서빙 (5173 → 컨테이너 80)
- db: MySQL 8.0 (3306)

네트워크: `safeview-net`

퍼시스턴스 볼륨:
- `db_data` → MySQL 데이터
- `camera_uploads` → AI 서버 업로드 파일
- `camera_api_results` → AI 서버 결과 파일

## 빠른 시작
1) .env 생성

```bash
cp .env.example .env
# 필요 시 값 수정 (비밀번호/키 등)
```

2) 빌드 및 실행

```bash
docker compose up -d --build
```

3) 접속
- Frontend: http://localhost:5173
- Backend (Spring): http://localhost:8080
- Camera-AI (FastAPI): http://localhost:8000/health

4) 로그 보기/중단

```bash
docker compose logs -f

docker compose down
```

## 환경변수 메모
`.env`로 오버라이드 가능하며, 기본값은 `docker-compose.yml` 내 주석 참고.

- DB
  - `MYSQL_ROOT_PASSWORD` / `MYSQL_DATABASE` / `MYSQL_USER` / `MYSQL_PASSWORD`
- Backend
  - `JWT_SECRET`
  - `AI_SERVER_API_KEY` (application.yml의 `api.internal.ai-server-key` 로 사용)
  - `AI_SERVER_URL` → Spring의 `ai.server.url` 로 매핑되며 기본값은 compose에서 `http://camera-ai:8000`
  - DB 접속은 내부에서 `jdbc:mysql://db:3306/...` 로 설정됨
- Camera-AI
  - `BACKEND_API_URL` 기본 `http://backend:8080`
  - `SPRING_MAKE_ENTITY_URL` 기본 `http://backend:8080/api/videos/make-entity`
  - `AI_API_KEY` → Backend에서 검증용 키와 일치 필요 시 `.env`에서 동일 값 사용
  - 선택: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `S3_BUCKET_NAME`, `S3_REGION`

## 프론트엔드 API 경로
현재 `services/frontend/src/apis/api.ts`에서 axios 기본 `baseURL`이 `http://localhost:8080/api` 로 하드코딩되어 있습니다. 로컬 브라우저에서 요청하는 것이므로 컨테이너 네트워킹과 무관하게 정상 동작합니다. (필요 시 `.env` 기반 `VITE_API_BASE_URL` 형태로 개선 가능)

## 개발 팁
- Backend 헬스체크(Actuator)를 쓰고 싶다면 `spring-boot-starter-actuator` 추가 후 `/actuator/health`를 compose healthcheck로 설정하세요.
- Apple Silicon(arm64)에서도 동작하도록 베이스 이미지를 선정했으나, 초기에 Python 휠 다운로드에 시간이 걸릴 수 있습니다.

## 트러블슈팅
- 포트 충돌 시: `docker-compose.yml`의 `ports`에서 호스트 포트를 변경하세요.
- 카메라 AI가 백엔드에 접근 못할 때: `BACKEND_API_URL`이 `http://backend:8080`인지 확인.
- CORS 에러 시: Backend CORS 설정을 확인하거나 필요 시 허용 도메인에 `http://localhost:5173` 추가.



## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FSafeView%2FProduction.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FSafeView%2FProduction?ref=badge_large)