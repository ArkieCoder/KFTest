
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
                    proximity < dispatch_candidate.proximity &&
                    !elevator.occupied
                )
                dispatch_candidate = elevator
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

    def proximity(req_floor)
        return (req_floor - @current_floor).abs
    end

    def request(req_floor)
        print "received request from floor #{req_floor}"
        error_msg = "ERROR: cannot go to non-existent floor __DIR__ current range - ignoring request"
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
        move_elevator(to_floor - @current_floor)
        open
        @occupied = false 
        print "made a trip from #@current_floor to #{to_floor}"
        @trip_count += 1
        if maintenance_required?
            @in_maintenance = true
        end
    end

    def clear_maintenance_indicator
        print "clearing maintenance indicator"
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
        print "moving elevator #{index} floors"
        index.abs.times do
            move_one_floor(index)
        end
        print "this elevator has passed #@floors_passed floors"
    end

    def move_one_floor(index)
        new_current_floor = @current_floor
        if index < 0
            new_current_floor -= 1
        else
            new_current_floor += 1
        end
        print "moving from #@current_floor to #{new_current_floor}"
        @current_floor = new_current_floor
        @floors_passed+=1
    end

    def open
        print "elevator door is open"
        @doors_open = true
    end

    def close
        print "elevator door is closed"
        @doors_open = false
    end
end