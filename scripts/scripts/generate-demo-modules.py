"""Generate the optional insurance data modules from synthetic, deterministic fixtures."""
from pathlib import Path
import json
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
# Folder, schema/table, purpose, typed fields, fixture values (one row per demo case).
MODULES = [
    ('Customers', 'customers', 'Khách hàng', [('full_name','TEXT NOT NULL'), ('email','TEXT NOT NULL UNIQUE'), ('city','TEXT NOT NULL')],
     [[f'Khach hang demo {i}', f'customer{i}@example.test', 'Ha Noi'] for i in range(1,6)]),
    ('Agents', 'agents', 'Đại lý bảo hiểm', [('full_name','TEXT NOT NULL'), ('email','TEXT NOT NULL UNIQUE'), ('commission_rate','NUMERIC(5,2) NOT NULL CHECK (commission_rate BETWEEN 0 AND 100)')],
     [[f'Dai ly demo {i}', f'agent{i}@example.test', 5+i] for i in range(1,6)]),
    ('Products', 'products', 'Sản phẩm bảo hiểm', [('product_name','TEXT NOT NULL'), ('category','TEXT NOT NULL'), ('base_premium','NUMERIC(14,2) NOT NULL CHECK (base_premium > 0)')],
     [[name,kind,amount] for name,kind,amount in [('Bao hiem xe','motor',1200000),('Bao hiem suc khoe','health',2500000),('Bao hiem nha','property',1800000),('Bao hiem du lich','travel',300000),('Bao hiem tai nan','accident',650000)]]),
    ('Quotes', 'quotes', 'Báo giá', [('customer_code','TEXT NOT NULL'), ('product_code','TEXT NOT NULL'), ('quoted_premium','NUMERIC(14,2) NOT NULL CHECK (quoted_premium > 0)')],
     [[f'CU{i:03}',f'PR{i:03}',a] for i,a in enumerate([1200000,2500000,1800000,300000,650000],1)]),
    ('Contracts', 'contracts', 'Hợp đồng bảo hiểm', [('quote_code','TEXT NOT NULL'), ('agent_code','TEXT NOT NULL'), ('starts_on','DATE NOT NULL'), ('ends_on','DATE NOT NULL CHECK (ends_on > starts_on)')],
     [[f'QU{i:03}',f'AG{i:03}','2026-01-01','2026-12-31'] for i in range(1,6)]),
    ('Billing', 'billing', 'Hóa đơn và số tiền cần thanh toán', [('contract_code','TEXT NOT NULL'), ('amount_due','NUMERIC(14,2) NOT NULL CHECK (amount_due > 0)'), ('due_on','DATE NOT NULL')],
     [[f'CO{i:03}',a,'2026-01-10'] for i,a in enumerate([1200000,2500000,1800000,300000,650000],1)]),
    ('Payments', 'payments', 'Giao dịch thanh toán', [('invoice_code','TEXT NOT NULL'), ('amount_paid','NUMERIC(14,2) NOT NULL CHECK (amount_paid > 0)'), ('payment_method',"TEXT NOT NULL CHECK (payment_method IN ('bank_transfer','card','cash'))")],
     [[f'BI{i:03}',a,'bank_transfer'] for i,a in enumerate([1200000,2500000,1800000,300000,650000],1)]),
    ('Claims', 'claims', 'Yêu cầu bồi thường', [('contract_code','TEXT NOT NULL'), ('incident_on','DATE NOT NULL'), ('claimed_amount','NUMERIC(14,2) NOT NULL CHECK (claimed_amount > 0)')],
     [[f'CO{i:03}','2026-03-15',i*100000] for i in range(1,6)]),
    ('Commissions', 'commissions', 'Hoa hồng đại lý', [('agent_code','TEXT NOT NULL'), ('contract_code','TEXT NOT NULL'), ('commission_amount','NUMERIC(14,2) NOT NULL CHECK (commission_amount >= 0)')],
     [[f'AG{i:03}',f'CO{i:03}',a*(5+i)/100] for i,a in enumerate([1200000,2500000,1800000,300000,650000],1)]),
    ('Renewals', 'renewals', 'Đề nghị gia hạn', [('contract_code','TEXT NOT NULL'), ('renewal_on','DATE NOT NULL'), ('renewal_premium','NUMERIC(14,2) NOT NULL CHECK (renewal_premium > 0)')],
     [[f'CO{i:03}','2027-01-01',a] for i,a in enumerate([1200000,2500000,1800000,300000,650000],1)]),
    ('Underwriting', 'underwriting', 'Thẩm định hồ sơ', [('quote_code','TEXT NOT NULL'), ('decision',"TEXT NOT NULL CHECK (decision IN ('approved','review','declined'))"), ('review_note','TEXT NOT NULL')],
     [[f'QU{i:03}','approved','Ho so gia lap du dieu kien'] for i in range(1,6)]),
    ('Risk', 'risk', 'Đánh giá rủi ro', [('customer_code','TEXT NOT NULL'), ('risk_score','INTEGER NOT NULL CHECK (risk_score BETWEEN 0 AND 100)'), ('risk_level',"TEXT NOT NULL CHECK (risk_level IN ('low','medium','high'))")],
     [[f'CU{i:03}',i*10,'low' if i<4 else 'medium'] for i in range(1,6)]),
    ('Notifications', 'notifications', 'Thông báo khách hàng', [('customer_code','TEXT NOT NULL'), ('channel',"TEXT NOT NULL CHECK (channel IN ('email','sms','portal'))"), ('message_body','TEXT NOT NULL')],
     [[f'CU{i:03}','portal',f'Hop dong CO{i:03} da duoc tao (du lieu demo)'] for i in range(1,6)]),
    ('Reporting', 'reporting', 'Báo cáo doanh thu mẫu', [('report_month','DATE NOT NULL'), ('product_code','TEXT NOT NULL'), ('premium_total','NUMERIC(14,2) NOT NULL CHECK (premium_total >= 0)')],
     [['2026-01-01',f'PR{i:03}',a] for i,a in enumerate([1200000,2500000,1800000,300000,650000],1)]),
    ('Audit', 'audit', 'Nhật ký thao tác mẫu', [('actor_code','TEXT NOT NULL'), ('action_name','TEXT NOT NULL'), ('entity_code','TEXT NOT NULL')],
     [[f'AG{i:03}','create_contract',f'CO{i:03}'] for i in range(1,6)]),
    ('Identity', 'identity', 'Tài khoản và vai trò mẫu', [('username','TEXT NOT NULL UNIQUE'), ('agent_code','TEXT NOT NULL'), ('role_name',"TEXT NOT NULL CHECK (role_name IN ('agent','admin','reviewer'))")],
     [[f'demo_agent_{i}',f'AG{i:03}','agent'] for i in range(1,6)]),
    ('Support', 'support', 'Phiếu hỗ trợ', [('customer_code','TEXT NOT NULL'), ('subject','TEXT NOT NULL'), ('ticket_status',"TEXT NOT NULL CHECK (ticket_status IN ('open','resolved','closed'))")],
     [[f'CU{i:03}','Huong dan thanh toan hop dong demo','open'] for i in range(1,6)]),
    ('Workflow', 'workflow', 'Công việc xử lý hồ sơ', [('contract_code','TEXT NOT NULL'), ('step_name','TEXT NOT NULL'), ('step_status',"TEXT NOT NULL CHECK (step_status IN ('pending','completed','failed'))")],
     [[f'CO{i:03}','issue_contract','completed'] for i in range(1,6)]),
]

def literal(value):
    if isinstance(value, (int,float)):
        return str(value)
    return "'" + value.replace("'", "''") + "'"

master = ['\\set ON_ERROR_STOP on', '-- Optional synthetic data in a dedicated database. All modules load atomically.', 'BEGIN;']
verification = ['\\set ON_ERROR_STOP on', 'BEGIN;']
counts = []
for folder, schema, purpose, fields, rows in MODULES:
    path = ROOT / folder
    path.mkdir(exist_ok=True)
    prefix = folder[:2].upper()
    codes = [f'{prefix}{i:03}' for i in range(1,6)]
    columns = [('code','TEXT PRIMARY KEY')] + fields
    ddl = '-- Optional demo module: ' + purpose + '\n'
    ddl += f'CREATE SCHEMA IF NOT EXISTS {schema};\nCREATE TABLE IF NOT EXISTS {schema}.records (\n'
    ddl += ',\n'.join(f'    {name} {kind}' for name,kind in columns) + '\n);\n'
    (path / 'schema.sql').write_text(ddl, encoding='utf-8')
    seed = '-- Fictional fixtures. Reruns preserve existing records with the same code.\n'
    seed += f"INSERT INTO {schema}.records ({', '.join(name for name,_ in columns)}) VALUES\n"
    seed += ',\n'.join('    (' + ', '.join(literal(v) for v in [code] + row) + ')' for code,row in zip(codes,rows))
    seed += '\nON CONFLICT (code) DO NOTHING;\n'
    (path / 'seed.sql').write_text(seed, encoding='utf-8')
    code_list = ', '.join(literal(code) for code in codes)
    check = f"DO $$ BEGIN\n    IF (SELECT COUNT(*) FROM {schema}.records WHERE code IN ({code_list})) <> 5 THEN\n        RAISE EXCEPTION 'Missing fixtures in {schema}';\n    END IF;\nEND $$;\n"
    (path / 'verify.sql').write_text(check, encoding='utf-8')
    (path / 'sample.json').write_text(json.dumps([dict(zip([name for name,_ in columns], [code]+row)) for code,row in zip(codes,rows)], ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    (path / 'README.md').write_text(f'# {purpose}\n\nPhần mở rộng dữ liệu demo, không phải một microservice .NET mới.\n\n- `schema.sql`: schema `{schema}`, bảng `records`, khóa chính và ràng buộc dữ liệu.\n- `seed.sql`: 5 bản ghi giả lập; chạy lại không ghi đè bản ghi đã tồn tại.\n- `verify.sql`: kiểm tra đủ 5 mã dữ liệu mẫu.\n- `sample.json`: cùng dữ liệu mẫu để tham khảo API/frontend.\n\nChạy từ thư mục gốc: `scripts/scripts/database-demo.ps1`. Script dùng CSDL riêng `lab_netmicro_demo`. Có thể chạy lần lượt ba file SQL bằng psql trong CSDL demo đã tạo.\n\nCác cột có hậu tố `_code` liên kết logic với các module khác. Bộ dữ liệu dùng chung mã mẫu; script kiểm tra tổng kiểm tra các liên kết. Không có khóa ngoại xuyên service; các bảng demo này chưa kết nối vào backend hiện tại.\n\nDữ liệu hoàn toàn giả lập; địa chỉ email dùng miền `example.test`. Identity chỉ minh họa username/role, chưa thực hiện đăng nhập hay lưu mật khẩu.\n', encoding='utf-8')
    for filename in ['schema.sql','seed.sql','verify.sql']:
        master.append(f'\\ir ../../{folder}/{filename}')
    verification.append(f'\\ir ../../{folder}/verify.sql')
    counts.append(f"SELECT '{folder}' AS module, COUNT(*) AS rows FROM {schema}.records")

master += ['\\ir verify-demo-links.sql', 'COMMIT;', '\nUNION ALL\n'.join(counts) + ';']
(ROOT / 'scripts/scripts/load-demo.sql').write_text('\n'.join(master)+'\n', encoding='utf-8')
verification += ['\\ir verify-demo-links.sql', 'COMMIT;', '\nUNION ALL\n'.join(counts) + ';']
(ROOT / 'scripts/scripts/verify-demo.sql').write_text('\n'.join(verification)+'\n', encoding='utf-8')
# Add the data files as solution items without creating empty .NET services.
solution_path = ROOT / 'InsuranceMicroservices.slnx'
tree = ET.parse(solution_path)
solution = tree.getroot()
for item in list(solution.findall('Folder')):
    if item.get('Name', '').startswith('/DataModules/'):
        solution.remove(item)
ET.SubElement(solution, 'Folder', Name='/DataModules/')
for folder, *_ in MODULES:
    group = ET.SubElement(solution, 'Folder', Name=f'/DataModules/{folder}/')
    for filename in ['README.md','schema.sql','seed.sql','verify.sql','sample.json']:
        ET.SubElement(group, 'File', Path=f'{folder}/{filename}')
ET.indent(tree, space='  ')
solution_path.write_text(ET.tostring(solution, encoding='unicode')+'\n', encoding='utf-8')
print(f'Generated {len(MODULES)} root modules, {len(MODULES)*5} module files and {len(MODULES)*5} synthetic records.')
