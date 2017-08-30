#!/usr/bin/ruby

class ElevatorSimulation
    def initialize(elevator_count, floor_count) 
        @elevator_count = elevator_count
        @floor_count = floor_count
        @elevators = Array.new
        elevator_count.times do
            @elevators << Elevator.new(@floor_count)
        end
    end

    def request(req_floor)
        dispatch_candidate = nil
        @elevators.each { |elevator|
            if !elevator.in_maintenance
                if elevator.current_floor == req_floor
                    dispatch_candidate = elevator
                    break
                end

                if elevator.occupied && (elevator.current_floor..elevator.moving_to_floor).cover?(req_floor)
                    dispatch_candidate = elevator
                    break
                end

                proximity = elevator.proximity(req_floor)
                if dispatch_candidate == nil ||
                    (
                        proximity < dispatch_candidate.proximity(req_floor) &&
                        !elevator.occupied
                    )
                    dispatch_candidate = elevator
                end
            end
        }
        dispatch_candidate.request(req_floor)
    end
end

class Elevator
    def initialize(floor_count) 
        @floor_count = floor_count
        @trip_count = 0
        @floors_passed = 0
        @current_floor = 1
        @occupied = false # occupied in the sense of 'on a trip', even though car may be empty
        @doors_open = false
        @in_maintenance = false
        @moving_to_floor = 1
    end

    def floor_count
        @floor_count
    end

    def trip_count
        @trip_count
    end

    def floors_passed
        @floors_passed
    end

    def current_floor
        @current_floor
    end

    def occupied
        @occupied
    end

    def doors_open
        @doors_open
    end

    def in_maintenance
        @in_maintenance
    end

    def moving_to_floor
        @moving_to_floor
    end

    def proximity(req_floor)
        return (req_floor - @current_floor).abs
    end

    def request(req_floor)
        print "received request from floor #{req_floor}\n"
        error_msg = "ERROR: cannot go to non-existent floor __DIR__ current range - ignoring request\n"
        if req_floor > @floor_count
            print error_msg.sub(/__DIR__/, "above")
        elsif req_floor < 1
            print error_msg.sub(/__DIR__/, "below")
        else
            make_trip(req_floor)
        end
    end

    def make_trip(to_floor)
        close
        @occupied = true
        @moving_to_floor = to_floor
        starting_floor = @current_floor
        move_elevator(to_floor - @current_floor)
        open
        @occupied = false 
        print "made a trip from #{starting_floor} to #{to_floor}\n"
        @trip_count += 1
        if maintenance_required?
            @in_maintenance = true
        end
    end

    def clear_maintenance_indicator
        print "clearing maintenance indicator\n"
        @in_maintenance = false
    end

    def maintenance_required?
        required = false
        if @trip_count % 100
            required = true
        end
        return required
    end

    def move_elevator(index) 
        print "moving elevator #{index} floors\n"
        index.abs.times do
            move_one_floor(index)
        end
        print "this elevator has passed #@floors_passed floors\n"
    end

    def move_one_floor(index)
        new_current_floor = @current_floor
        if index < 0
            new_current_floor -= 1
        else
            new_current_floor += 1
        end
        print "moving from #@current_floor to #{new_current_floor}\n"
        @current_floor = new_current_floor
        @floors_passed+=1
    end

    def open
        print "elevator door is open\n"
        @doors_open = true
    end

    def close
        print "elevator door is closed\n"
        @doors_open = false
    end
end

es = ElevatorSimulation.new(2,10)
es.request(5)