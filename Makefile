.PHONY: up down status logs verify-isolation

up:
	docker-compose up -d

down:
	docker-compose down

status:
	docker-compose ps

logs:
	docker-compose logs -f --tail=50

verify-isolation:
	@echo "=== [1/2] App -> Database (Harus BERHASIL) ==="
	@docker run --rm --network container:stratum_app alpine:3.22 sh -c 'nc -zvw3 postgres 5432' || exit 1
	@echo ""
	@echo "=== [2/2] Proxy -> Database (Harus GAGAL) ==="
	@docker run --rm --network container:stratum_proxy alpine:3.22 sh -c 'nc -zvw3 postgres 5432' && { echo "FAILED: Proxy dapat menjangkau Database"; exit 1; } || echo "SUCCESS: Proxy tidak dapat menjangkau Database"