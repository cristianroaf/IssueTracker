require 'swagger_helper'

RSpec.describe 'issues', type: :request do

  path '/issues' do

    get('list issues') do
      tags 'Issues'
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('create issue') do
      tags 'Issues'
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/new' do

    get('new issue') do
      tags 'Issues'
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{id}/edit' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('edit issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    patch('update issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    put('update issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    delete('delete issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/' do

    get('list issues') do
      tags 'Issues'
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{id}/attachment' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show_attachment issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end

    post('create_attachment issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{id}/vote' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    post('vote issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{id}/watch' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    post('watch issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end

  path '/issues/{id}/status' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    put('update_status issue') do
      tags 'Issues'
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end
        run_test!
      end
    end
  end
end
