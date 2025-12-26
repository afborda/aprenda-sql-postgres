-- ============================================
-- CRIAÇÃO DE TABELAS COM RELACIONAMENTOS
-- ============================================

-- Tabela: users
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: posts
CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    views INT DEFAULT 0,
    likes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: comments
CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    likes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: transactions (para análise de fraudes)
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL, -- 'purchase', 'transfer', 'withdrawal'
    merchant VARCHAR(150),
    payment_method VARCHAR(50), -- 'credit_card', 'debit_card', 'boleto', 'pix'
    location_city VARCHAR(100),
    location_state VARCHAR(2),
    ip_address VARCHAR(45),
    device_type VARCHAR(50), -- 'mobile', 'desktop', 'tablet'
    status VARCHAR(20) DEFAULT 'completed', -- 'completed', 'pending', 'failed'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela: fraud_data (detecção de fraudes)
CREATE TABLE IF NOT EXISTS fraud_data (
    id SERIAL PRIMARY KEY,
    transaction_id INT NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    fraud_type VARCHAR(100), -- 'credit_card_fraud', 'identity_theft', 'account_takeover', 'suspicious_activity'
    fraud_score DECIMAL(3, 2), -- 0.00 a 1.00 (probabilidade de fraude)
    is_fraud BOOLEAN DEFAULT FALSE,
    reason TEXT,
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'open' -- 'open', 'resolved', 'false_positive'
);

-- Tabela: user_accounts (contas bancárias/cartões)
CREATE TABLE IF NOT EXISTS user_accounts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_type VARCHAR(50), -- 'credit_card', 'debit_card', 'bank_account'
    account_number VARCHAR(20) UNIQUE,
    account_holder VARCHAR(150),
    card_last_digits VARCHAR(4),
    balance DECIMAL(15, 2) DEFAULT 0.00,
    credit_limit DECIMAL(15, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- DADOS DE EXEMPLO
-- ============================================

-- Inserir usuários
INSERT INTO users (username, email, full_name, cpf, phone, address, city, state, zip_code) VALUES
('joao_silva', 'joao.silva@email.com', 'João da Silva Santos', '123.456.789-00', '(11) 98765-4321', 'Rua A, 100', 'São Paulo', 'SP', '01000-000'),
('maria_oliveira', 'maria.oliveira@email.com', 'Maria Oliveira Costa', '234.567.890-11', '(21) 99876-5432', 'Avenida B, 200', 'Rio de Janeiro', 'RJ', '20000-000'),
('carlos_santos', 'carlos.santos@email.com', 'Carlos Santos Ferreira', '345.678.901-22', '(31) 97654-3210', 'Rua C, 300', 'Belo Horizonte', 'MG', '30000-000'),
('ana_pereira', 'ana.pereira@email.com', 'Ana Pereira Mendes', '456.789.012-33', '(41) 98432-1098', 'Avenida D, 400', 'Curitiba', 'PR', '80000-000'),
('pedro_gomes', 'pedro.gomes@email.com', 'Pedro Gomes Alves', '567.890.123-44', '(51) 99123-4567', 'Rua E, 500', 'Porto Alegre', 'RS', '90000-000'),
('lucia_martins', 'lucia.martins@email.com', 'Lúcia Martins da Silva', '678.901.234-55', '(85) 98765-0123', 'Avenida F, 600', 'Fortaleza', 'CE', '60000-000'),
('felipe_rocha', 'felipe.rocha@email.com', 'Felipe Rocha Barbosa', '789.012.345-66', '(61) 97654-8901', 'Rua G, 700', 'Brasília', 'DF', '70000-000'),
('beatriz_castro', 'beatriz.castro@email.com', 'Beatriz Castro Lima', '890.123.456-77', '(71) 98901-2345', 'Avenida H, 800', 'Salvador', 'BA', '40000-000'),
('rafael_dias', 'rafael.dias@email.com', 'Rafael Dias Cardoso', '901.234.567-88', '(81) 99234-5678', 'Rua I, 900', 'Recife', 'PE', '50000-000'),
('isabela_nunes', 'isabela.nunes@email.com', 'Isabela Nunes Ribeiro', '012.345.678-99', '(47) 98765-4321', 'Avenida J, 1000', 'Joinville', 'SC', '89000-000');

-- Inserir posts
INSERT INTO posts (user_id, title, content, views, likes) VALUES
(1, 'Dicas de Segurança Digital', 'Aprenda a proteger suas informações pessoais na internet com estas práticas simples e eficazes.', 150, 45),
(2, 'Como Economizar Dinheiro', 'Estratégias práticas para economizar e investir melhor seu dinheiro no dia a dia.', 320, 98),
(3, 'Fraudes Online: Como se Proteger', 'Guia completo sobre os tipos de fraude mais comuns e como evitá-las.', 510, 167),
(4, 'Investimento para Iniciantes', 'Começando do zero: um guia prático para começar a investir com segurança.', 280, 75),
(5, 'Tecnologia e Segurança Bancária', 'Entenda como os bancos protegem seus dados e quais tecnologias usam.', 420, 125),
(6, 'Cartão de Crédito: Vantagens e Riscos', 'Saiba como usar cartão de crédito de forma inteligente sem cair em armadilhas.', 360, 110),
(7, 'PIX: O Futuro do Pagamento', 'Tudo que você precisa saber sobre o novo sistema de pagamento instantâneo.', 650, 210),
(8, 'Cibersegurança para Pequenos Negócios', 'Como proteger seu negócio contra ataques cibernéticos e fraudes.', 290, 88),
(9, 'Autenticação de Dois Fatores', 'Por que você deve ativar 2FA em todas as suas contas e como fazer.', 410, 135),
(10, 'Tendências de Segurança em 2025', 'As principais tendências e desafios em segurança da informação para o próximo ano.', 540, 165);

-- Inserir comentários
INSERT INTO comments (post_id, user_id, content, likes) VALUES
(1, 2, 'Excelente conteúdo! Vou aplicar todas essas dicas.', 12),
(1, 3, 'Muito útil, obrigado pela informação!', 8),
(2, 4, 'Já estou economizando 30% do meu salário com suas dicas.', 25),
(3, 5, 'Infelizmente caí em uma fraude. Seus conselhos são ouro.', 18),
(4, 6, 'Finalmente entendi como começar a investir!', 22),
(5, 7, 'Adorei aprender sobre as tecnologias de segurança.', 15),
(6, 8, 'Usando cartão com mais cuidado agora.', 10),
(7, 9, 'PIX mudou completamente minha forma de pagar.', 35),
(8, 10, 'Muito importante para quem tem negócio online.', 14),
(9, 1, 'Já ativei 2FA em todos os meus apps!', 19),
(10, 2, 'Excelente análise das tendências futuras.', 11);

-- Inserir contas de usuários
INSERT INTO user_accounts (user_id, account_type, account_number, account_holder, card_last_digits, balance, credit_limit, is_active) VALUES
(1, 'credit_card', '4111111111111111', 'João da Silva Santos', '1111', 2500.00, 5000.00, TRUE),
(1, 'bank_account', '001-123456-1', 'João da Silva Santos', NULL, 15000.00, NULL, TRUE),
(2, 'credit_card', '5555555555554444', 'Maria Oliveira Costa', '4444', 3200.00, 8000.00, TRUE),
(2, 'debit_card', '001-234567-2', 'Maria Oliveira Costa', '4444', 8500.00, NULL, TRUE),
(3, 'credit_card', '378282246310005', 'Carlos Santos Ferreira', '0005', 1800.00, 4000.00, TRUE),
(3, 'bank_account', '001-345678-3', 'Carlos Santos Ferreira', NULL, 22000.00, NULL, TRUE),
(4, 'credit_card', '6011111111111117', 'Ana Pereira Mendes', '1117', 4100.00, 10000.00, TRUE),
(5, 'debit_card', '001-456789-4', 'Pedro Gomes Alves', '1234', 12500.00, NULL, TRUE),
(6, 'credit_card', '3714496353622522', 'Lúcia Martins da Silva', '2522', 2900.00, 6000.00, TRUE),
(7, 'bank_account', '001-567890-5', 'Felipe Rocha Barbosa', NULL, 18000.00, NULL, TRUE);

-- Inserir transações
INSERT INTO transactions (user_id, amount, transaction_type, merchant, payment_method, location_city, location_state, ip_address, device_type, status) VALUES
(1, 150.50, 'purchase', 'Supermercado ABC', 'credit_card', 'São Paulo', 'SP', '192.168.1.100', 'mobile', 'completed'),
(1, 250.00, 'transfer', 'PIX Transfer', 'pix', 'São Paulo', 'SP', '192.168.1.100', 'mobile', 'completed'),
(2, 89.99, 'purchase', 'Amazon Brasil', 'credit_card', 'Rio de Janeiro', 'RJ', '192.168.1.101', 'desktop', 'completed'),
(2, 500.00, 'withdrawal', 'Caixa Eletrônico', 'debit_card', 'Rio de Janeiro', 'RJ', '192.168.1.101', 'mobile', 'completed'),
(3, 1200.00, 'purchase', 'Passagem Aérea Gol', 'credit_card', 'Belo Horizonte', 'MG', '192.168.1.102', 'desktop', 'completed'),
(3, 45.00, 'purchase', 'Netflix', 'credit_card', 'Belo Horizonte', 'MG', '192.168.1.102', 'tablet', 'completed'),
(4, 320.75, 'purchase', 'Farmácia Genérica', 'debit_card', 'Curitiba', 'PR', '192.168.1.103', 'mobile', 'completed'),
(5, 2500.00, 'purchase', 'Loja de Eletrônicos', 'credit_card', 'Porto Alegre', 'RS', '192.168.1.104', 'desktop', 'completed'),
(6, 110.00, 'purchase', 'Restaurante Italiano', 'credit_card', 'Fortaleza', 'CE', '192.168.1.105', 'mobile', 'completed'),
(7, 180.50, 'purchase', 'Uber', 'credit_card', 'Brasília', 'DF', '192.168.1.106', 'mobile', 'completed');

-- Inserir dados de fraude (casos suspeitos e fraudulosos)
INSERT INTO fraud_data (transaction_id, user_id, fraud_type, fraud_score, is_fraud, reason, status) VALUES
(1, 1, 'suspicious_activity', 0.15, FALSE, 'Transação normal, localização consistente', 'false_positive'),
(3, 2, 'suspicious_activity', 0.25, FALSE, 'Compra online verificada', 'false_positive'),
(5, 3, 'suspicious_activity', 0.35, FALSE, 'Passagem aérea - compra legítima', 'false_positive'),
(7, 4, 'suspicious_activity', 0.18, FALSE, 'Compra farmácia próxima à residência', 'false_positive'),
(8, 5, 'credit_card_fraud', 0.92, TRUE, 'Compra de valor muito alto em novo dispositivo', 'open'),
(9, 6, 'suspicious_activity', 0.45, FALSE, 'Compra em restaurante durante horário comercial', 'resolved');

-- ============================================
-- ÍNDICES PARA MELHOR PERFORMANCE
-- ============================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_cpf ON users(cpf);
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_fraud_data_user_id ON fraud_data(user_id);
CREATE INDEX idx_fraud_data_is_fraud ON fraud_data(is_fraud);
CREATE INDEX idx_fraud_data_status ON fraud_data(status);
CREATE INDEX idx_user_accounts_user_id ON user_accounts(user_id);
CREATE INDEX idx_user_accounts_is_active ON user_accounts(is_active);

-- ============================================
-- CONSTRAINTS ADICIONAIS
-- ============================================

ALTER TABLE transactions ADD CONSTRAINT chk_amount_positive CHECK (amount > 0);
ALTER TABLE user_accounts ADD CONSTRAINT chk_balance_non_negative CHECK (balance >= 0);
ALTER TABLE transactions ADD CONSTRAINT chk_amount_positive CHECK (amount > 0);
ALTER TABLE user_accounts ADD CONSTRAINT chk_balance_non_negative CHECK (balance >= 0);
ALTER TABLE fraud_data ADD CONSTRAINT chk_fraud_score CHECK (fraud_score >= 0.00 AND fraud_score <= 1.00);














































