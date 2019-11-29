require 'swagger_helper'

RSpec.describe 'comments', type: :request do

  path '/issues/{issue_id}/comments' do
    # You'll want to customize the parameter types...
    parameter name: 'issue_id', in: :path, type: :string, description: 'issue_id'

    get('list comments') do
      response(200, 'successful') do
        let(:issue_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('create comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{issue_id}/comments/new' do
    # You'll want to customize the parameter types...
    parameter name: 'issue_id', in: :path, type: :string, description: 'issue_id'

    get('new comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{issue_id}/comments/{id}/edit' do
    # You'll want to customize the parameter types...
    parameter name: 'issue_id', in: :path, type: :string, description: 'issue_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('edit comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{issue_id}/comments/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'issue_id', in: :path, type: :string, description: 'issue_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('update comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    put('update comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('delete comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{issue_id}/comments/{id}/attachment' do
    # You'll want to customize the parameter types...
    parameter name: 'issue_id', in: :path, type: :string, description: 'issue_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show_attachment comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('create_attachment comment') do
      response(200, 'successful') do
        let(:issue_id) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
